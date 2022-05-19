# Remove DX

リモートワークを快適にするあれこれ

# リモート開発環境

Windows/MacのDockerが遅い、ディスクを圧迫する問題を解消するため、AWS EC2上のLinuxマシンで開発する

## Required

- [tailscale](https://tailscale.com/)
- [VS Code / Remote Development extension pack](https://code.visualstudio.com/docs/remote/ssh)
- [Terraform](https://www.terraform.io/)
  - 環境構築にのみ使用

## 環境構築

```
git clone git@github.com:sora-corporation/remote-dx.git
cd terraform
# main.tf > terraform > cloud の設定を適宜変更
terraform init
terraform plan
terraform apply -auto-approve
# またはTerraform Cloudの管理画面から
# Workspace Variablesを設定した後[Run]
```
