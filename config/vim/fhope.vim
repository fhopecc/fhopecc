"fhope.vim
"
"fhope@2006/6/10 下午 07:10:22
"
function! TagWord(tag)
	let cmd="normal i<".a:tag.">\<esc>ea</".a:tag.">\<esc>"
	exec cmd
endfunction
function! TagLine(tag)
  let res="<".a:tag.">".getline(".")."</".a:tag.">"
	cal setline(".",res)
endfunction
function! MakeSegList(col,row)
	let cmd="normal o<segmentedlist>\<enter><?dbhtml list-presentation=\"table\"?>\<enter>"
  let i = 1
	let row="<seglistitem>\<enter>"
	while i <=a:col
		let cmd=cmd."<segtitle>\<enter></segtitle>\<enter>"
		let row=row."<seg>\<enter></seg>\<enter>"
		let i=i+1
	endwhile
	let row=row."</seglistitem>\<enter>"
	let i=1
  while i <= a:row
		let cmd=cmd.row
		let i=i+1
	endwhile
	let cmd=cmd."</segmentedlist>\<enter>"
	exec cmd
endfunction
function! MakeTitle(sect)
  let res="<".a:sect."><title>".getline(".")."</title>"
	cal setline(".",res)
endfunction
function! Exp(base, exp)
  let lnum = 1
  let res=1
  while lnum <= a:exp
    let res = res*a:base
    let lnum = lnum + 1
  endwhile
	return res
endfunction

function! AppendList(list)
	for i in a:list
    let str = str."<entry>".i."</entry>"
	endfor
	call append(i, str)
endfunction

function! AppendTable(table)
	let i=line(".")
	call append(i, "<table><title></title>")
	let i=i+1
	call append(i, '<tgroup cols="'.len(a:table[0]).'">')
	let i=i+1
	call append(i, "<tbody>")
	let i=i+1
  "make table body
	for row in a:table
	  call append(i, "<row>")
	  let i=i+1
		for entry in row
			call append(i, "<entry>".entry."</entry>")
	    let i=i+1
		endfor
		call append(i, "</row>")
	  let i=i+1
	endfor
	call append(i, "</tbody>")
	let i=i+1
	call append(i, "</tgroup>")
	let i=i+1
	call append(i, "</table>")
endfunction

function! InversionTable(list)
	let sorted = sort(copy(a:list))
	let ilist=InversionList(a:list)
	"add title
	call insert(sorted, '排序陣列')
	call insert(a:list, '原始陣列')
	call insert(ilist, '反轉表')
  let itable=([sorted, a:list, ilist])
	call AppendTable(itable)
endfunction

function! ReverseArray(list)
	let sorted = sort(copy(a:list))
	let reversed = reverse(copy(sorted))

	call insert(a:list, '原始陣列')
	call insert(sorted, '排序陣列')
	call insert(reversed, '反序陣列')
  let itable=([sorted, a:list, reversed])
	call AppendTable(itable)
endfunction

function! InversionList(list)
	let sorted = sort(copy(a:list))
	let ilist=[]
  for item in sorted
    let i=index(a:list, item)
	  let j=i-1
		let d=0
	  while j >= 0
	    if a:list[j] > item
        let d=d+1
			endif
			let j=j-1
		endwhile
		call add(ilist, d)
	endfor
	return ilist
endfunction

" 加入編輯戳記
function! ChangeStamp()
:ruby << EOF
  require 'vimext'
	ins_author_stamp
EOF
endfunction	

function! InsFName()
:ruby << EOF
  require 'vimext'
	ins_fname
EOF
endfunction
