
## Setup

```bash
git clone https://github.com/lloydeverett/lua-cosmologist
cd lua-cosmologist
wget https://github.com/jart/cosmopolitan/releases/download/4.0.2/cosmocc-4.0.2.zip
unzip cosmocc-4.0.2.zip -d cosmocc
rm cosmocc-4.0.2.zip
```

## Usage

```bash
cd example
../cosmologist .
./bin/example
```

See the [platform notes listed here](https://github.com/jart/cosmopolitan?tab=readme-ov-file#platform-notes) if you have any difficulty running the output binary.

## Installation

```bash
mkdir -p "$HOME/.local/bin"
ln -s $(realpath ./cosmologist) "$HOME/.local/bin/cosmologist"
```

Then ensure `~/.local/bin` is on your shell `$PATH` (either install `envman` or append `export PATH="$HOME/.local/bin:$PATH"` to your shell profile).

