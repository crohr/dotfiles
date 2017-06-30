#!/bin/bash
set -ex
set -o pipefail

MY_USER=crohr
MY_HOME=/home/$MY_USER

mkdir -p $MY_HOME/.ssh
chmod 0700 $MY_HOME/.ssh
curl -L https://github.com/crohr.keys >> $MY_HOME/.ssh/authorized_keys
chmod 0600 $MY_HOME/.ssh/authorized_keys
chown -R crohr:crohr $MY_HOME/.ssh

sed -i "s|PasswordAuthentication yes|PasswordAuthentication no|" /etc/ssh/sshd_config
sshd -t
service ssh restart

id $MY_USER || useradd -d $MY_HOME --shell /bin/bash -m $MY_USER
echo 'crohr    ALL = NOPASSWD: ALL' > /etc/sudoers.d/crohr

workspace=$(mktemp -d)
apt-get update -qq
apt-get install -y \
	apt-transport-https \
	ca-certificates \
	curl \
	software-properties-common \
	jq \
	htop \
	vim \
	git \
	ntp \
	sudo \
	wget \
	tmux \
	bash-completion \
	cron

# docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository \
	"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
	$(lsb_release -cs) \
	 stable"
# rcm
add-apt-repository -y ppa:martin-frost/thoughtbot-rcm
# virtualbox
echo 'deb http://download.virtualbox.org/virtualbox/debian yakkety contrib' > /etc/apt/sources.list.d/virtualbox.list
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -


wget -qO - https://deb.packager.io/key | apt-key add -
echo "deb https://deb.packager.io/gh/pkgr/docker-gc xenial pkgr" | tee /etc/apt/sources.list.d/docker-gc.list

apt-get update -qq
apt-get install -y \
	docker-ce \
	docker-gc \
	rcm \
	virtualbox-dkms \
	virtualbox

getent group docker || groupadd docker
usermod -aG docker $MY_USER

# Install vagrant
LATEST_VAGRANT_URL=$(curl -s https://releases.hashicorp.com/vagrant/index.json \
    | jq --raw-output \
        '.versions
        | with_entries(select(.key | test("-rc[0-9]+$") | not))
        | to_entries
        | max_by(.key)
        | .value.builds[]
        | select(.arch=="x86_64")
        | select(.os=="debian")
        | .url')

curl "$LATEST_VAGRANT_URL" -o $workspace/vagrant.deb
dpkg -i $workspace/vagrant.deb

# outside of su so that we can use ssh agent forwarding
test -d $MY_HOME/.dotfiles || git clone https://github.com/crohr/dotfiles $MY_HOME/.dotfiles
GIT_DIR=$MY_HOME/.dotfiles/.git git pull origin master
chown -R $MY_USER:$MY_USER $MY_HOME/.dotfiles

su -l crohr -c "
mkdir -p ~/dev
rm -rf $MY_HOME/.vim/bundle/Vundle.vim
git clone https://github.com/gmarik/Vundle.vim.git $MY_HOME/.vim/bundle/Vundle.vim
rcup -x install.sh
vim +PluginInstall +qall
echo 'Host *
  PubkeyAcceptedKeyTypes=+ssh-dss' > $MY_HOME/.ssh/config
"
