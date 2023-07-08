import numpy as np
from scipy.optimize import linear_sum_assignment
import cv2


def get_fast_aji(true, pred):
    """
    AJI version distributed by MoNuSeg, has no permutation problem but suffered from
    over-penalisation similar to DICE2
    Fast computation requires instance IDs are in contiguous orderding i.e [1, 2, 3, 4]
    not [2, 3, 6, 10]. Please call `remap_label` before hand and `by_size` flag has no
    effect on the result.
    """
    true = np.copy(true)  # ? do we need this
    pred = np.copy(pred)
    true_id_list = list(np.unique(true))
    pred_id_list = list(np.unique(pred))

    true_masks = [None, ]
    for t in true_id_list[1:]:
        t_mask = np.array(true == t, np.uint8)
        true_masks.append(t_mask)

    pred_masks = [None, ]
    for p in pred_id_list[1:]:
        p_mask = np.array(pred == p, np.uint8)
        pred_masks.append(p_mask)

    # prefill with value
    pairwise_inter = np.zeros([len(true_id_list) - 1,
                               len(pred_id_list) - 1], dtype=np.float64)
    pairwise_union = np.zeros([len(true_id_list) - 1,
                               len(pred_id_list) - 1], dtype=np.float64)
    # 多检
    pairwise_FP = np.zeros([len(true_id_list) - 1,
                            len(pred_id_list) - 1], dtype=np.float64)
    # 漏检
    pairwise_FN = np.zeros([len(true_id_list) - 1,
                            len(pred_id_list) - 1], dtype=np.float64)

    # caching pairwise
    for true_id in true_id_list[1:]:  # 0-th is background
        t_mask = true_masks[true_id]
        pred_true_overlap = pred[t_mask > 0]
        pred_true_overlap_id = np.unique(pred_true_overlap)
        pred_true_overlap_id = list(pred_true_overlap_id)
        for pred_id in pred_true_overlap_id:
            if pred_id == 0:  # ignore
                continue  # overlaping background
            p_mask = pred_masks[pred_id]
            total = (t_mask + p_mask).sum()
            inter = (t_mask * p_mask).sum()
            pairwise_inter[true_id - 1, pred_id - 1] = inter
            pairwise_union[true_id - 1, pred_id - 1] = total - inter

            pairwise_FP[true_id - 1, pred_id - 1] = p_mask.sum() - inter
            pairwise_FN[true_id - 1, pred_id - 1] = t_mask.sum() - inter
    #
    pairwise_iou = pairwise_inter / (pairwise_union + 1.0e-6)
    # pair of pred that give highest iou for each true, dont care
    # about reusing pred instance multiple times
    paired_pred = np.argmax(pairwise_iou, axis=1)
    pairwise_iou = np.max(pairwise_iou, axis=1)
    # exlude those dont have intersection
    paired_true = np.nonzero(pairwise_iou > 0.0)[0]
    paired_pred = paired_pred[paired_true]
    # print(paired_true.shape, paired_pred.shape)

    overall_inter = (pairwise_inter[paired_true, paired_pred]).sum()
    overall_union = (pairwise_union[paired_true, paired_pred]).sum()

    overall_FP = (pairwise_FP[paired_true, paired_pred]).sum()
    overall_FN = (pairwise_FN[paired_true, paired_pred]).sum()

    #
    paired_true = (list(paired_true + 1))  # index to instance ID
    paired_pred = (list(paired_pred + 1))
    # add all unpaired GT and Prediction into the union
    unpaired_true = np.array([idx for idx in true_id_list[1:] if idx not in paired_true])
    unpaired_pred = np.array([idx for idx in pred_id_list[1:] if idx not in paired_pred])

    less_pred = 0
    more_pred = 0

    for true_id in unpaired_true:
        less_pred += true_masks[true_id].sum()
        overall_union += true_masks[true_id].sum()
    for pred_id in unpaired_pred:
        more_pred += pred_masks[pred_id].sum()
        overall_union += pred_masks[pred_id].sum()
    #
    aji_score = overall_inter / overall_union
    fm = overall_union - overall_inter
    print('\t [ana_FP = {:.4f}, ana_FN = {:.4f}, ana_less = {:.4f}, ana_more = {:.4f}]'.format((overall_FP / fm),
                                                                                               (overall_FN / fm),
                                                                                               (less_pred / fm),
                                                                                               (more_pred / fm)))

    return aji_score, overall_FP / fm, overall_FN / fm, less_pred / fm, more_pred / fm

from skimage import io
import os
from skimage import measure
import skimage.morphology as morph
if __name__ == '__main__':
    # root_path = 'D:\Desktop\datas'
    # gt_path = os.path.join(root_path, 'U20S_GT')
    # pred_path = os.path.join(root_path, 'U20S_Seg_our')
    # gt_list = os.listdir(gt_path)
    # pred_list = os.listdir(pred_path)
    # for gt in gt_list:
    #     s = gt.split('.')[0]
    #     s_ = s.split('-')[1]
    #     if len(s_) == 1:
    #         s_ = '0' + s_
    #         gt_ = 'GT-' + s_ + '.png'
    #         gt_path_ori = os.path.join(gt_path, gt)
    #         gt_path_new = os.path.join(gt_path, gt_)
    #         print(gt_path_ori, gt_path_new)
    #         os.rename(gt_path_ori, gt_path_new)


    root_path = 'D:\Desktop\datas'
    gt_path = os.path.join(root_path, 'U20S_GT')
    pred_path = os.path.join(root_path, 'U20S_Seg')
    gt_list = os.listdir(gt_path)
    pred_list = os.listdir(pred_path)
    gt_list.sort()
    pred_list.sort()
    aji_score_list = []
    for gt, pred in zip(gt_list, pred_list):
        # print(gt, pred)
        gt_img = os.path.join(gt_path, gt)
        pred_img = os.path.join(pred_path, pred)
        label_img = io.imread(gt_img)
        pred_labeled = io.imread(pred_img)
        pred_labeled = measure.label(pred_labeled)
        pred_labeled = morph.dilation(pred_labeled, selem=morph.selem.disk(3))
        pred_labeled = measure.label(pred_labeled)
        gt_labeled = measure.label(label_img)
        aji_score, _, _, _, _ = get_fast_aji(gt_labeled, pred_labeled)
        aji_score_list.append(aji_score)

    print('Mean AJI Score: {:.4f}'.format(sum(aji_score_list) / len(aji_score_list)))



