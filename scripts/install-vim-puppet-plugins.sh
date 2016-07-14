#!/bin/bash
# Some useful plugins: http://vimawesome.com/

## The following gems are needed:
gem install puppet-lint   || exit 1            # http://puppet-lint.com/   
gem install puppet-syntax || exit 1

mkdir -p ~/.vim/autoload ~/.vim/bundle || exit 1

curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim || exit 1

cd ~/.vim/bundle || exit 1

git clone https://github.com/scrooloose/syntastic.git || exit 1
git clone git://github.com/rodjek/vim-puppet.git      || exit 1
git clone git://github.com/godlygeek/tabular.git      || exit 1
git clone https://github.com/scrooloose/nerdtree.git  || exit 1

# vim snippets and shipmate:

git clone https://github.com/tomtom/tlib_vim.git              || exit 1 
git clone https://github.com/MarcWeber/vim-addon-mw-utils.git || exit 1
git clone https://github.com/garbas/vim-snipmate.git          || exit 1
git clone https://github.com/honza/vim-snippets.git           || exit 1

echo "execute pathogen#infect()" > ~/.vimrc                     || exit 1 
echo "syntax on" >> ~/.vimrc                                    || exit 1
echo "filetype plugin indent on" >> ~/.vimrc                    || exit 1
echo "filetype on" >> ~/.vimrc                                  || exit 1
echo "set statusline+=%#warningmsg#" >> ~/.vimrc                || exit 1
echo "set statusline+=%{SyntasticStatuslineFlag()}" >> ~/.vimrc || exit 1
echo "set statusline+=%*" >> ~/.vimrc                           || exit 1
echo "let g:syntastic_always_populate_loc_list = 1" >> ~/.vimrc || exit 1
echo "let g:syntastic_auto_loc_list = 1" >> ~/.vimrc            || exit 1
echo "let g:syntastic_check_on_open = 1" >> ~/.vimrc            || exit 1
echo "let g:syntastic_check_on_wq = 1" >> ~/.vimrc              || exit 1

# http://vim.wikia.com/wiki/Indenting_source_code
echo "set expandtab" >> ~/.vimrc     || exit 1
echo "set shiftwidth=2" >> ~/.vimrc  || exit 1
echo "set softtabstop=2" >> ~/.vimrc || exit 1
# In vim, to automatically reindent, do "gg=G" while in vim's navigation mode. 


echo 'PATH=$PATH:/home/vagrant/bin' >> /home/vagrant/.bashrc  || exit 1 # this is to get puppet lint to work. 


# here's some extra configurations to make vim easier to use:

cat /vagrant/files/.vimrc >> ~/.vimrc || exit 1

echo "--no-80chars-check" >> ~/.puppet-lint.rc || exit 1   # http://stackoverflow.com/questions/29206887/puppet-lint-configuration-file
                                                           # https://github.com/rodjek/puppet-lint#puppet-lint-1

