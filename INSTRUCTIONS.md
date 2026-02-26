# Running the Pipeline with Docker

This guide explains how to run the Phenoscript pipeline on **Windows**, **macOS**, or **Linux** using Docker — no manual software installation required.

---

## Step 1 — Install Docker Desktop

Docker is the only software you need to install.

| Platform | Download |
|---|---|
| Windows | https://docs.docker.com/desktop/install/windows-install/ |
| macOS | https://docs.docker.com/desktop/install/mac-install/ |
| Linux | https://docs.docker.com/desktop/install/linux-install/ |

After installation, **start Docker Desktop** and wait until it shows a green "Engine running" status before proceeding.

---

## Step 2 — Download this Repository

Click **Code → Download ZIP** on the GitHub page, then unzip it anywhere on your computer.

Or, if you have Git:
```bash
git clone https://github.com/sergeitarasov/Phenoscript-Cuiaba-2026.git
```

---

## Step 3 — Run the Pipeline

Open the folder you just downloaded/unzipped. Run the script for your operating system:

### Windows
Double-click **`run_docker.bat`**

> If Windows shows a security warning, click **"More info" → "Run anyway"**.

### macOS
Double-click **`run_docker.command`**

> The first time only: right-click the file → **Open** → **Open** (this bypasses macOS Gatekeeper). After that, double-clicking works normally.

### Linux
Open a terminal in the repository folder and run:
```bash
./run_docker.sh
```

---

## What Happens

1. Docker downloads the pre-built pipeline image from GitHub (~first run only, cached after that).
2. The pipeline runs inside the container (`make` executes all steps).
3. Results are written directly to your computer — no manual copying needed.

The terminal window stays open so you can see progress and any errors.

---

## Output Files

After the pipeline finishes, find the results inside the `main/` folder:

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

---

## Re-running the Pipeline

Just run the same script again. The image is already cached locally, so it starts immediately.

---

## Troubleshooting

**"Docker: command not found" / script does nothing**
- Make sure Docker Desktop is installed and running (green icon in system tray / menu bar).

**"Error response from daemon: pull access denied"**
- The image is not yet published, or the image name changed. Contact the course organizer.

**Pipeline fails mid-way**
- Check `main/log/shacl.log` and `main/log/materializer.log` for error details.
- On Windows, the terminal window stays open after a failure — read the error message before closing.

**"Permission denied" on macOS/Linux**
- Open a terminal in the repository folder and run:
  ```bash
  chmod +x run_docker.command run_docker.sh
  ```

**Out of memory during reasoning**
- Docker Desktop defaults to 2 GB RAM for containers. Open Docker Desktop → **Settings → Resources** and increase Memory to at least 8 GB.
