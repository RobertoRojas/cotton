# Cotton

This script provide you the option to expand the behaviour of a command or add more in your shell like a custom function.

## Implementations

### execute 

This function run the content of .cotton_execute into the current folder, command:

```bash
execute [clear|help] <path>
```

### cd

This function overwrite the behavior of the cd command to add the execution of something when entering or exiting a folder with .cotton_cd.

```bash
cd [help]
```

## How to install

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/RobertoRojas/cotton/v1.0/setup.sh)";
```

### Author

Roberto Rojas