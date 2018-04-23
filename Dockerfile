# escape=`

# This docker image is going to be huge! :'(

# use base image with dotnet3.5 because it's the hardest one to install
FROM microsoft/dotnet-framework:3.5-windowsservercore-1709

# install chocolatey
RUN powershell -Command Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Install all the dotnets required
RUN powershell -Command choco install -y dotnetcore DotNet4.0

# We need 7z to unpack the ISOs
RUN powershell -Command choco install -y 7zip

# Unfortunately, the choco packages don't really work for our needs so we have
# to install a bunch of MSIs manually. Fun times!
COPY *.ps1 /scripts/

# Install the content from DVDs, starting with 2008
RUN powershell -Command /scripts/install_tools.ps1 -InstallURI https://download.microsoft.com/download/2/E/9/2E911956-F90F-4BFB-8231-E292A7B6F287/GRMSDK_EN_DVD.iso
RUN powershell -Command /scripts/install_tools.ps1 -InstallURI http://download.microsoft.com/download/F/1/0/F10113F5-B750-4969-A255-274341AC6BCE/GRMSDK_EN_DVD.iso
RUN powershell -Command /scripts/copy_dlls.ps1

# update redists to whatever is latest
RUN powershell -Command choco install -y vcredist2010 vcredist2008

