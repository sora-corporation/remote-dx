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
# terraform.tfvars.exampleに記載した各値を設定し
# terraform.tfvarsに配置
terraform init
terraform plan
terraform apply -auto-approve
# またはTerraform Cloudの管理画面からWorkspace Variablesに
# terraform.tfvars.exampleに記載した各値を設定した後[Run]
# （`TF_VAR_変数名` で設定）
```

ローカルPCにtailscaleをセットアップし、VPCプライベートサブネット内に構築された `under-tailscale` のEC2インスタンスのプライベートIPアドレスに通信できることを確認
```
ping 10.0.1.x
```

### SSH接続

`~.ssh/config`  

```
Host 10.0.1.x
  User ec2-user
  IdentityFile ~/.ssh/[developer_pubkeyで指定した公開鍵とペアの秘密鍵]
  PubkeyAuthentication yes
  PasswordAuthentication no
  ServerAliveInterval 30
```

```
ssh 10.0.1.x

# EC2インスタンス上でGitHubからcloneするなら
eval `ssh-agent`
ssh-add ~/.ssh/[GitHubの秘密鍵]
ssh 10.0.1.x
```

# 参考リンク

- https://tailscale.com/kb/1021/install-aws/
- https://dev.classmethod.jp/articles/launch-tailscale-vpn-on-amazon-lightsail-in-1-min/
