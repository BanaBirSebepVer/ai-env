# PowerShell için TLS 1.2 zorunlu kıl
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Miniconda dizini
$CONDA_DIR = "C:\Miniconda3"

# 1. Miniconda yoksa indir ve kur
if (!(Test-Path -Path $CONDA_DIR)) {
    Write-Host "🔽 Miniconda indiriliyor..."
    Invoke-WebRequest -Uri "https://repo.anaconda.com/miniconda/Miniconda3-latest-Windows-x86_64.exe" -OutFile "miniconda.exe"

    Write-Host "⚙️ Kurulum başlatılıyor..."
    Start-Process -Wait -FilePath ".\miniconda.exe" -ArgumentList "/InstallationType=JustMe", "/AddToPath=1", "/RegisterPython=0", "/S", "/D=$CONDA_DIR"

    Remove-Item ".\miniconda.exe"
} else {
    Write-Host "✅ Miniconda zaten kurulu."
}

# Conda aktivasyon komutu
$condaActivate = "$CONDA_DIR\Scripts\activate.bat"

# 2. Ortamı oluşturmak için environment.yml dosyasını indir
Write-Host "🌐 environment.yml dosyası indiriliyor..."
Invoke-WebRequest -Uri "https://github.com/BanaBirSebepVer/ai-env/raw/b97a0632c53731e2823cd1d14e60a4da73bb641a/environment.yml" -OutFile "environment.yml"

# 3. Conda ortamını yml dosyasından oluştur
Write-Host "🛠️ Ortam oluşturuluyor (ai-env)..."
cmd /c "call `"$condaActivate`" && conda env create -f environment.yml -n ai-env"

# 4. Ekstra pip paketleri yükleniyor
Write-Host "📦 Ekstra kütüphaneler yükleniyor..."
cmd /c "call `"$condaActivate`" && conda activate ai-env && pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118 && pip install ray[default] numpy pandas matplotlib"

Write-Host "`n✅ Her şey başarıyla tamamlandı. Ortam: ai-env"