Before getting started
1. clone IHP open source PDK
> `cd ~`<br>
> `git clone https://github.com/IHP-GmbH/IHP-Open-PDK.git`<br>
> `cd IHP-Open-PDK`<br>
> `cp -r ihp-sg13g2 ~/share/pdks/.`<br>
2. install openvaf and compile the most models
> `cd ~`<br>
> `wget https://openva.fra1.cdn.digitaloceanspaces.com/openvaf_23_5_0_linux_amd64.tar.gz`<br>
> `tar -xf openvaf_23_5_0_linux_amd64.tar.gz`<br>
`./openvaf ./IHP-Open-PDK/ihp-sg13g2/libs.tech/ngspice/openvaf/psp103_nqs.va`<br>
`cp ./IHP-Open-PDK/ihp-sg13g2/libs.tech/ngspice/openvaf/psp103_nqs.osdi <some_path>/.`<br>

