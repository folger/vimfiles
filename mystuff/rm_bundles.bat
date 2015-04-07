set @bundles=vim-airline ^
vim-colors-solarized ^
vim-repeat ^
vim-abolish ^
tabular ^
tagbar ^
summerfruit256.vim ^
syntastic ^
scratch.vim ^
sparkup ^
nerdtree ^
python-mode ^
hexman ^
clang_complete ^
gundo ^
buffet.vim

pushd ..\bundle
for %%x in (%@bundles%) do (
	pushd %%x
	del /q *
	for /d %%y in (.) do (
		rd /s /q %%y
	)
	popd
)
popd
