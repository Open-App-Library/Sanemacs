#!/bin/sh

# Install Sanemacs with one fell swoop
# Example: curl https://sanemacs.com/bootstrap.sh | sh

mkdir -p ~/.emacs.d
curl https://sanemacs.com/sanemacs.el > ~/.emacs.d/sanemacs.el

[ -f ~/.emacs.d/init.el ] cp ~/.emacs.d/init.el ~/.emacs.d/init.el.backup
echo "(load \"~/.emacs.d/sanemacs.el\")" > ~/.emacs.d/init.el
