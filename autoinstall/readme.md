autoinstall
--

## Create disk that automate system installation using preseed

    ./build.sh

## Encrypt /home using dm-crypt

See this article: [https://noyuno.github.io/blog/2017/04/09/crypto/](https://noyuno.github.io/blog/2017/04/09/crypto/)

### Install system

#### Launch system install disk

#### Partitioning

    # Your /dev/sda data is going to lost
    ./install.sh /dev/sda 20G

#### Install system

#### Create luks USB

    # Your /dev/sdb1 data is going to lost
    ./install.sh luks /dev/sdb1


### Option: Add luks USB after installation system

    ./luks.sh /dev/sdb1

