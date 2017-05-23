# brew upgrade
# brew doctor
# fix any problems like this
# You should change the ownership and permissions of these directories.
# back to your user account.
#  sudo chown -R $(whoami) /usr/local/include /usr/local/lib /usr/local/lib/pkgconfig
# brew install llvm --force

cd ..
git clone https://github.com/trill-lang/ClangSwift
cd ClangSwift
swift utils/make-pkgconfig.swift
cd ..
cd WrapGen
swift build
