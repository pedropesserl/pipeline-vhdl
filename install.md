# Como instalar a IDE, ISE, para desenvolvimento com fpga e vhdl
- Dowload arquivo
  - [ISE Design](https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/vivado-design-tools/archive-ise.html)
  - 14.7 tem 4 partes, baixar todas
- Packages necessarios
    - packages do arch, verificar sua distro em busca de parecidos
      - ncurses5-compat-libs
      - libstdc++5
      - fxloaid
      - digilent.adept.runtime(AUR)*
      - digilent.adept.utilities(AUR)*
      - openmotif
      - xorg-fonts-75dpi
      - xorg-fonts-100dpi
    - **apenas arch, ver [] para baixar em outras distros*
- Extraindo os arquivos
    - Crie uma pasta xilinx. `mkdir xilinx`
    - Mova os arquivos baixados para ela. `mv Xilinx_* xilinx`
    - Descompacte apenas a parte 1. `cd xilinx; tar -xvf <Xilinx_ISE_parte_1.tar>`
- Shell padrão
    - Verifique seu shell. `ls -l /usr/bin/sh`
    - Se não for `lrwxrwxrwx 1 root root 15 13 Mar 06:47 /usr/bin/sh -> bash`, use `ln -sfT bash /usr/bin/sh`
- Instalando
    - Execute o arquivo xsetup. `sudo ./xsetup`
    - Verifique que o diretório `/opt/Xilinx` pode ser escrito (Se nao existir não faça nada)
    - Vai aparcer a tela de instalação do Xilinx
    - Colocar o diretório de onde estao o outros arquivos .tar (Provavelmente em `xilinx`)
    - Gerar uma licença, seguir o passo a passo do instalador
    - selecionar o Web-Pack
    - Descelecionar a opção "Install Cable Drivers"
- Criado desktop
    - Crie o arquivo "/usr/share/applications/ise.desktop". `sudo vim /usr/share/applications/ise.desktop`
    - Copiar o script no arquivo
    ```
    [Desktop Entry]
        Version=1.0
        Type=Application
        Name=Xilinx ISE
        Exec=sh -c "unset LANG && unset QT_PLUGIN_PATH && source /opt/Xilinx/14.7/ISE_DS/settings64.sh && ise"
        Icon=/opt/Xilinx/14.7/ISE_DS/ISE/data/images/pn-ise.png
        Categories=Development;
        Comment=Xilinx ISE
        StartupWMClass=_pn
    ```
- Baixando dependencias em outras distros
    - Baixar [DIGILENT ADEPT](https://digilent.com/shop/software/digilent-adept/)
    - Baixar as opções Adpet Runtime e Adpet Utilities
    - Se baixar a .deb é só executar ela, baixando a .tar.gz eh preciso descompactar
    - Entrar no diretório criado e instalar.
      ```bash
      tar -xzvf <digilent_adpet.tar.gz>
      cd <digilent_adpet.tar.gz>
      sudo ./install.sh
      ```
- Conseguindo a licença
    - http://xilinx.com/getlicense.html
    - Marque todas as caixinhas na seção Certificate Based Licenses
    - Clique no botão Generate Node-Locked License
    - Insira as informações do seu PC
        - Host name (nome do PC)
        - Operating System (Linux 64-bit)
        - Host ID type (Ethernet MAC)
        - Host ID value:
            - rode o comando `/sbin/ifconfig`
            - copie o número depois da primeira aparição da palavra `ether` na saída do comando
    - Clique em Add
    - Ele vai te mandar um email, abra e baixe o arquivo .lic
    - Abra o Xilinx ISE
    - Ele vai reclamar que não tem licença; siga os passos e vá na aba onde tem um botão "load license"
    - Suba o arquivo que você baixou por email

- Pronto, abrir e codar :)
