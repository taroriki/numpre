/************************************ 整数値(32bit)のリスト構造 *******************************************/
#module List ele_cnt, ele_max, start_idx, end_idx, now_idx, next_idx, back_idx, value, enable

	#define SORT_ASC  0 // 昇順ソート
	#define SORT_DESC 1 // 降順ソート
	
	// コンストラクタ(使用する最大要素数で初期化する)
	#modinit int size
		dim value, size    // データ(32bit整数値)
		dim next_idx, size // 要素毎の次の要素を示すインデックスを記録
		dim back_idx, size // 要素毎の前の要素を示すインデックスを記録
		dim enable, size   // 使用済みデータフラグ(空き領域には0が入る)
		start_idx = -1 // リストの先頭のインデックス
		end_idx = -1   // リストの末尾のインデックス
		now_idx = -1   // リストの現在のインデックス
		ele_cnt = 0    // 現在の要素数
		ele_max = size // 最大要素数
		return

	// リストの末尾に要素を追加
	#modfunc ListAddVal int in_val		
		mref ret, 64 // stat変数(エラー検知用)		
		for i, 0, ele_max
			if enable(i) == 0 : _break
		next
		if i == ele_max { // 最大要素数のため、これ以上追加できない
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

	// 現在のインデックスの前に要素を追加
	#modfunc ListInsVal int in_val
		mref ret, 64 // stat変数(エラー検知用)
		for i, 0, ele_max
			if enable(i) == 0 : _break
		next
		if i == ele_max{ // 最大要素数のため、これ以上追加できない
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

	// 現在のインデックスの要素をリストから削除
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

	// 現在のインデックスをリストの先頭に設定
	#modfunc ListCurStart
		now_idx = start_idx
		return

	// 現在のインデックスをリストの末尾に設定
	#modfunc ListCurEnd
		now_idx = end_idx
		return

	// 現在のインデックスを一つ進める
	#modfunc ListCurNext
		mref ret, 64 // stat変数(エラー検知用)
		now_idx = next_idx(now_idx)
		if now_idx == -1 { ret = -1 }
		else             { ret = 0 }
		return

	// 現在のインデックスを一つ戻す
	#modcfunc ListCurBack
		mref ret, 64 // stat変数(エラー検知用)
		now_idx = back_idx(now_idx)
		if now_idx == -1 { ret = -1 }
		else             { ret = 0 }
		return

	// 現在のインデックスをリストのi番目に設定
	#modfunc ListCurSet int in_i
		mref ret, 64 // stat変数(エラー検知用)
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

	// 現在のインデックスの値を取得
	#modcfunc ListGetVal
		return value(now_idx)

	// 現在のインデックスに値を設定
	#modfunc ListSetVal int in_val
		value(now_idx)=in_val
		return

	// リストの要素数を取得
	#modcfunc ListGetCnt
		return ele_cnt

	// リストをソートする
	#modfunc ListSort int AscDesc
		p1 = start_idx
		if AscDesc == SORT_DESC { // 降順ソート
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
		else {                    // 昇順ソート(Default)
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

/************************* 使用方法 ***************************/
/*
newmod l1, List, 10 // 10要素までのリストをl1変数に割り当て
newmod l2, List, 20 // 20要素までのリストをl2変数に割り当て
// リストの末尾に値を追加していく
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
// リストのカーソルを3番目に設定(※0番目が先頭)
ListCurSet l1, 3
ListCurSet l2, 3
// 設定されたカーソルの要素を削除
ListDelEle l1
ListDelEle l2
// リストのカーソルを先頭に設定
ListCurStart l1
ListCurStart l2
// リストを降順にソート
ListSort l1, SORT_DESC@List
// リスト要素の値を全て表示
ret = 0
while ret == 0
	mes ListGetVal(l1) // 現在のカーソルの値を取得
	ListCurNext l1 // カーソルを次へ進める
	ret = stat
wend
// リスト要素の値を全て表示
ret = 0
while ret == 0
	mes ListGetVal(l2) // 現在のカーソルの値を取得
	ListCurNext l2 // カーソルを次へ進める
	ret = stat
wend
// 使い終わったら解放する
delmod l1
delmod l2
*/
/**************************************************************/
