# Welcome to the Phenoscript Workshop!

<p align="left">
  <img src="https://raw.githubusercontent.com/sergeitarasov/PhenoScript/main/phenospy.png" width="200" title="Phenospy logo">
  <img src="https://raw.githubusercontent.com/sergeitarasov/vscode-phenoscript/main/icon.png" width="200" title="Phenoscript logo">
</p>

## Workshop Overview

- Set up the PhenoScript environment for writing descriptions (VS Code)
- Install the Phenospy Python package for converting descriptions into natural language
- Explore semantic descriptions and ontology structure

---

## Part 1 — Writing PhenoScript Descriptions

### Step 1 — Download the Repository

Click **Code → Download ZIP** (the green button) on the [workshop GitHub page](https://github.com/sergeitarasov/Phenoscript-Cuiaba-2026), then unzip it anywhere on your computer.

### Step 2 — Set Up VS Code

Install [VS Code](https://code.visualstudio.com/) and the **PhenoScript extension** from the VS Code Marketplace.

Detailed setup instructions:
https://github.com/diegosasso/workshop_ISH2023/wiki/Configure-Phenoscript-VS-Code

> If you only want to write PhenoScript descriptions without converting them into hyperlinked text, VS Code + the extension is all you need.

### Step 3 — Configure Your Project

Open `main/phenotypes/phs-config.yaml` in VS Code and fill in:
- Project authors
- A short project title

### Step 4 — Write Your Descriptions

An example description is available at:
`main/phenotypes/grebennikovius_descriptions.phs`

Before starting, read the introduction to the PhenoScript language:
https://github.com/sergeitarasov/PhenoScript/wiki/Introduction-to-Phenoscript-Language

---

## Part 2 — Converting Descriptions to Natural Language and RDF

This part uses Docker to run the full pipeline. Docker bundles all required tools so you do not need to install them individually.

### Step 5 — Install Docker

**Windows and macOS** — install Docker Desktop:

| Platform | Download |
|---|---|
| Windows | https://docs.docker.com/desktop/install/windows-install/ |
| macOS | https://docs.docker.com/desktop/install/mac-install/ |

After installation, **start Docker Desktop** and wait until it shows a green "Engine running" status.

**Linux** — install Docker Engine (no Desktop needed):

```bash
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER
```

Then **log out and back in**, and verify the installation:

```bash
docker run hello-world
```

### Step 6 — Run the Pipeline

Open the unzipped repository folder and run the script for your operating system:

**Windows** — double-click `run_docker.bat`
> If Windows shows a security warning, click **"More info" → "Run anyway"**.

**macOS** — double-click `run_docker.command`
> First time only: right-click → **Open** → **Open** to bypass Gatekeeper. After that, double-clicking works normally.

**Linux** — open a terminal in the repository folder and run:
```bash
./run_docker.sh
```

### What happens when you run the script

1. Docker builds the pipeline image (~5 min on first run, instant after that due to caching).
2. The pipeline runs all conversion steps automatically (`make`).
3. Results are written directly to your computer — no manual copying needed.

The terminal window stays open so you can see progress and any errors.

### Output files

Results are saved inside the `main/` folder:

```
main/
├── output/
│   ├── *.owl              ← OWL ontology files
│   ├── *.ttl              ← Turtle RDF files
│   └── NL/
│       ├── *.html         ← Natural language descriptions (HTML)
│       └── *.md           ← Natural language descriptions (Markdown)
└── log/
    ├── shacl.log          ← SHACL validation report
    └── materializer.log   ← Reasoning log
```

To re-run the pipeline after editing your descriptions, just run the same script again.

---

## Part 3 — Exploring the Semantic Description

Install [Protégé](https://protege.stanford.edu/) and open the generated ontology file:
`main/output/grebennikovius-final.ttl`

This lets you inspect the graph structure of your data.

**Recommended exercise:** complete the Pizza Ontology tutorial to become familiar with ontologies:
https://www.michaeldebellis.com/post/new-protege-pizza-tutorial

> This tutorial is highly recommended but may take several hours.

---

## Troubleshooting

**Script does nothing / "Docker: command not found"**
- **Windows/macOS:** make sure Docker Desktop is installed and running (green icon in the system tray / menu bar).
- **Linux:** make sure Docker Engine is installed and your user is in the `docker` group (see Step 5).

**Pipeline fails mid-way**
- Check `main/log/shacl.log` and `main/log/materializer.log` for details.
- On Windows, the terminal stays open after a failure — read the error before closing.

**"Permission denied" on macOS/Linux**
- Open a terminal in the repository folder and run:
  ```bash
  chmod +x run_docker.command run_docker.sh
  ```

**Out of memory during reasoning**
- **Windows/macOS:** Docker Desktop caps container memory at 2 GB by default. Open Docker Desktop → **Settings → Resources** and increase Memory to at least 8 GB.
- **Linux:** Docker Engine uses system RAM directly — ensure your machine has at least 8 GB free.

---

## Extra Links

| Resource | Link |
|---|---|
| Intro to ontologies and key concepts | https://github.com/diegosasso/workshop_ISH2023/wiki/General-Concept |
| Grebennikovius paper | https://bdj.pensoft.net/article/121562/ |
| PhenoScript language syntax | https://github.com/sergeitarasov/PhenoScript/wiki/Introduction-to-Phenoscript-Language |
| PhenoScript wiki and exercises | https://github.com/sergeitarasov/PhenoScript/wiki |
| Additional PhenoScript examples | https://github.com/g-montanaro/phenoscript_grebennikovius |
| Protégé ontology editor | https://protege.stanford.edu/ |

---

## Funding and Sponsorship

Academy of Finland (grants 346294 and 339576)
