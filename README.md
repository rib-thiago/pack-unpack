# pack-unpack

This is a bash script that allows you to compress files using various compression tools. It supports the following compression options:

-   tar
-   tar.gz
-   tar.bz2
-   zip
-   rar

The user is prompted to choose the compression tool or can pass the desired compression format via command line arguments. and the script creates a compressed output file with the chosen tool and file extension. A progress bar is displayed while the compression is running and a successful completion message is displayed at the end.

## Pré-requisitos

-   Bash shell
-   Compression tools (tar, zip, rar)

## Installation

To use the `compress.sh` script, follow these steps:

1. Clone the repository: `git clone https://github.com/rib-thiago/pack-unpack.git`
2. Navigate to the directory where the script is located: `cd compress`
3. Make the script executable: `chmod +x compress.sh`
4. Run the script: `./compress.sh`

## Usage

To use the script, simply run it with the files you want to compress as arguments, like so:

```bash {.line-numbers}
./compress.sh file1.txt file2.txt
```

You can also specify a compression option using the following flags:

-   -t for tar
-   -g for tar.gz
-   -b for tar.bz2
-   -z for zip
-   -r for rar

For example, to create a tar archive of some files, you can run:

```bash {.line-numbers}
./compress.sh -t file1.txt file2.txt
```

If you do not specify a compression option, the script will display a menu for you to choose from.

## Progress Bar

While the compression is running, a progress bar will be displayed to show the progress of the compression. Once the compression is complete, the script will display a message with the name of the output file.

## Help

To display the help message for the script, simply run:

```bash {.line-numbers}
./compress.sh -h
```

This will display a list of available options and their descriptions.

## Error Handling

If you do not specify any files to compress, the script will display an error message and exit with an error code of 1.

If you specify an invalid option, the script will display an error message and exit with an error code of 1.

If the compression process fails, the script will exit with an error code of 1.

## License

This script is licensed under the MIT License. Feel free to use, modify, and distribute it as you like.
