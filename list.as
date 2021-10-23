/************************************ �����l(32bit)�̃��X�g�\�� *******************************************/
#module List ele_cnt, ele_max, start_idx, end_idx, now_idx, next_idx, back_idx, value, enable

	#define SORT_ASC  0 // �����\�[�g
	#define SORT_DESC 1 // �~���\�[�g
	
	// �R���X�g���N�^(�g�p����ő�v�f���ŏ���������)
	#modinit int size
		dim value, size    // �f�[�^(32bit�����l)
		dim next_idx, size // �v�f���̎��̗v�f�������C���f�b�N�X���L�^
		dim back_idx, size // �v�f���̑O�̗v�f�������C���f�b�N�X���L�^
		dim enable, size   // �g�p�ς݃f�[�^�t���O(�󂫗̈�ɂ�0������)
		start_idx = -1 // ���X�g�̐擪�̃C���f�b�N�X
		end_idx = -1   // ���X�g�̖����̃C���f�b�N�X
		now_idx = -1   // ���X�g�̌��݂̃C���f�b�N�X
		ele_cnt = 0    // ���݂̗v�f��
		ele_max = size // �ő�v�f��
		return

	// ���X�g�̖����ɗv�f��ǉ�
	#modfunc ListAddVal int in_val		
		mref ret, 64 // stat�ϐ�(�G���[���m�p)		
		for i, 0, ele_max
			if enable(i) == 0 : _break
		next
		if i == ele_max { // �ő�v�f���̂��߁A����ȏ�ǉ��ł��Ȃ�
			ret = -1
			return
		}
		enable(i) = 1
		value(i) = in_val
		next_idx(i) = -1
		back_idx(i) = end_idx
		if ele_cnt > 0 : next_idx(end_idx) = i
		if ele_cnt == 0 {
			start_idx = i
			now_idx = i
		}
		end_idx = i
		ele_cnt++
		ret = 0
		return

	// ���݂̃C���f�b�N�X�̑O�ɗv�f��ǉ�
	#modfunc ListInsVal int in_val
		mref ret, 64 // stat�ϐ�(�G���[���m�p)
		for i, 0, ele_max
			if enable(i) == 0 : _break
		next
		if i == ele_max{ // �ő�v�f���̂��߁A����ȏ�ǉ��ł��Ȃ�
			ret = -1
			return
		}
		if ele_cnt == 0 { bi = -1 }
		else            { bi = back_idx(now_idx) }
		enable(i) = 1
		value(i) = in_val
		if bi != -1 : next_idx(bi) = i
		next_idx(i) = now_idx
		back_idx(i) = bi
		if now_idx != -1 : back_idx(now_idx) = i
		if now_idx == start_idx : start_idx = i
		now_idx = i
		ele_cnt++
		ret = 0
		return

	// ���݂̃C���f�b�N�X�̗v�f�����X�g����폜
	#modfunc ListDelEle
		bi = back_idx(now_idx)
		ni = next_idx(now_idx)
		if bi != -1 : next_idx(bi) = ni
		if ni != -1 : back_idx(ni) = bi
		if start_idx == now_idx : start_idx = ni
		if end_idx == now_idx : end_idx = bi
		enable(now_idx) = 0
		now_idx = ni
		ele_cnt--
		return

	// ���݂̃C���f�b�N�X�����X�g�̐擪�ɐݒ�
	#modfunc ListCurStart
		now_idx = start_idx
		return

	// ���݂̃C���f�b�N�X�����X�g�̖����ɐݒ�
	#modfunc ListCurEnd
		now_idx = end_idx
		return

	// ���݂̃C���f�b�N�X����i�߂�
	#modfunc ListCurNext
		mref ret, 64 // stat�ϐ�(�G���[���m�p)
		now_idx = next_idx(now_idx)
		if now_idx == -1 { ret = -1 }
		else             { ret = 0 }
		return

	// ���݂̃C���f�b�N�X����߂�
	#modcfunc ListCurBack
		mref ret, 64 // stat�ϐ�(�G���[���m�p)
		now_idx = back_idx(now_idx)
		if now_idx == -1 { ret = -1 }
		else             { ret = 0 }
		return

	// ���݂̃C���f�b�N�X�����X�g��i�Ԗڂɐݒ�
	#modfunc ListCurSet int in_i
		mref ret, 64 // stat�ϐ�(�G���[���m�p)
		p = start_idx
		for i, 0, ele_max
			if i == in_i : _break
			p = next_idx(p)
			if p == -1 : _break
		next
		if p == -1 {
			ret = -1
			return
		}
		now_idx = p
		ret = 0
		return

	// ���݂̃C���f�b�N�X�̒l���擾
	#modcfunc ListGetVal
		return value(now_idx)

	// ���݂̃C���f�b�N�X�ɒl��ݒ�
	#modfunc ListSetVal int in_val
		value(now_idx)=in_val
		return

	// ���X�g�̗v�f�����擾
	#modcfunc ListGetCnt
		return ele_cnt

	// ���X�g���\�[�g����
	#modfunc ListSort int AscDesc
		p1 = start_idx
		if AscDesc == SORT_DESC { // �~���\�[�g
			while p1 != -1
				p2 = next_idx(p1)
				max = value(p1)
				while p2 != -1
					if max < value(p2) {
						max = value(p2)
						mem = value(p1)
						value(p1) = max
						value(p2) = mem
					}
					p2 = next_idx(p2)					
				wend
				p1 = next_idx(p1)
			wend
		}
		else {                    // �����\�[�g(Default)
			while p1 != -1
				p2 = next_idx(p1)
				min = value(p1)
				while p2 != -1
					if min > value(p2) {
						min = value(p2)
						mem = value(p1)
						value(p1) = min
						value(p2) = mem
					}
					p2 = next_idx(p2)
				wend
				p1 = next_idx(p1)
			wend
		}
		return
		
	#modfunc Debug
		p = start_idx
		While p!=-1
			mes "S"+value(p)
			p = next_idx(p)
		wend
		p = end_idx
		While p!=-1
			mes "E"+value(p)
			p = back_idx(p)
		wend
		return
#global
/**********************************************************************************************************************************/

/************************* �g�p���@ ***************************/
/*
newmod l1, List, 10 // 10�v�f�܂ł̃��X�g��l1�ϐ��Ɋ��蓖��
newmod l2, List, 20 // 20�v�f�܂ł̃��X�g��l2�ϐ��Ɋ��蓖��
// ���X�g�̖����ɒl��ǉ����Ă���
ListAddVal l1, 1
ListAddVal l1, 2
ListAddVal l1, 3
ListAddVal l1, 4
ListAddVal l1, 5
ListAddVal l1, 6
ListAddVal l2, -1
ListAddVal l2, -2
ListAddVal l2, -3
ListAddVal l2, -4
ListAddVal l2, -5
ListAddVal l2, -6
// ���X�g�̃J�[�\����3�Ԗڂɐݒ�(��0�Ԗڂ��擪)
ListCurSet l1, 3
ListCurSet l2, 3
// �ݒ肳�ꂽ�J�[�\���̗v�f���폜
ListDelEle l1
ListDelEle l2
// ���X�g�̃J�[�\����擪�ɐݒ�
ListCurStart l1
ListCurStart l2
// ���X�g���~���Ƀ\�[�g
ListSort l1, SORT_DESC@List
// ���X�g�v�f�̒l��S�ĕ\��
ret = 0
while ret == 0
	mes ListGetVal(l1) // ���݂̃J�[�\���̒l���擾
	ListCurNext l1 // �J�[�\�������֐i�߂�
	ret = stat
wend
// ���X�g�v�f�̒l��S�ĕ\��
ret = 0
while ret == 0
	mes ListGetVal(l2) // ���݂̃J�[�\���̒l���擾
	ListCurNext l2 // �J�[�\�������֐i�߂�
	ret = stat
wend
// �g���I�������������
delmod l1
delmod l2
*/
/**************************************************************/
