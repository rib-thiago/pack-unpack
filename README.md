# 📦 **Pack-Unpack** 📦

## 🎯 **Descrição**

O **Pack-Unpack** é uma ferramenta simples e eficaz para listar o conteúdo de pacotes compactados e arquivos. Ele suporta arquivos nos formatos **ZIP**, **RAR**, **TAR**, **BZ2** e **GZ**. Com suporte para uma variedade de formatos, você pode facilmente visualizar os arquivos dentro de pacotes compactados.

## 🚀 **Recursos**

Certifique-se de ter os seguintes programas instalados no seu sistema:

- `tar` para pacotes TAR/BZ2/GZ
- `zip` e `unzip` para pacotes ZIP
- `rar` e `unrar` para pacotes RAR

## 📜 **Uso**

- Para listar o conteúdo de pacotes: 

### Exemplo de Comando

```bash
./pack-unpack.sh -l arquivo1.zip
```

### Exemplo de Saída

```bash
Modo: LISTAGEM

Pacote:

arquivo1.zip

Conteúdo:

a.txt
b.txt

```

- usar no mode interativo:

```bash
./pack-unpack.sh -i
```


## 📝 **Notas**

- Certifique-se de tornar o script executável:
```bash
 chmod +x pack-unpack.sh
 ```


---
👤 Feito por [Thiago Ribeiro](https://github.com/rib-thiago)
