# NAT Instance Network

NATインスタンスとプライベートネットワークのAWS CloudFormationテンプレートです。費用を抑えたNATゲートウェイの代替で、非本番環境に適しています。

## 特徴

### コスト効率

* `t4g.nano` スポットインスタンスによる最小のEC2稼働コスト
* 最小のEBSサイズ（1GB）

### パフォーマンス/信頼性

* 多数のクライアントに対応できるよう、NATテーブルサイズを調整
* 問題発生時はNATインスタンスを自動で置き替え（IPv4アドレスはそのまま）
* IPv6サポート
* ...ただし、NATゲートウェイに劣っています :-)

### セキュリティ

* NATインスタンスの自動更新
* 一部の不正なパケットを破棄するようカーネルパラメータを調整
* NATインスタンスプロファイルのIAM権限を最小化

## 始めるには

AWSリージョンがサポートされているリージョンにあることを確認してください。

### AWSマネジメントコンソール

1. [CloudFormation] -> [スタック] -> [スタックの作成] -> [新しいリソースを使用 (標準)] を選択
2. テンプレートソースを [テンプレートファイルのアップロード] に指定し、`cf-nat-instance-network.yml` をテンプレートファイルとしてアップロードし、[次へ] をクリック
3. スタック名を指定し、[次へ] をクリック
4. [レビュー] 画面に到達するまで [次へ] で先に進む
5. [機能] 項目を確認し、問題なければチェックボックスをチェックし、[送信] をクリックします。

### CLI

```bash
aws cloudformation create-stack --stack-name YOUR_STACK_NAME --template-body "file://$(realpath cf-nat-instance-network.yml)" --capabilities CAPABILITY_IAM
```

### 次のステップ

`YOUR_STACK_NAME-PrivateSubnetA` という名前のプライベートサブネットがありますので、そこに必要なインスタンスを配置してください。

## 運用費用の例

* EC2 `t4g.nano` スポットインスタンス: 1.3〜1.6 USD/月
* EBS: 0.096 USD/月
* 受信トラフィック: 無料
* 送信トラフィック: トラフィック量に依存、[月間100GBの無料利用枠あり](https://aws.amazon.com/blogs/aws/aws-free-tier-data-transfer-expansion-100-gb-from-regions-and-1-tb-from-amazon-cloudfront-per-month/)

注：価格は2023年9月時点でのap-northeast-1リージョンに基づいています。

## パラメータ

* `EC2NATInstanceInstanceType`
  * NATインスタンスのEC2インスタンスタイプ。
  * デフォルトの `t4g.nano` は最小のEC2稼働コスト。
* `EC2NATInstanceKeyName`
  * NATインスタンスへのSSHログインを行いたい場合、キーペア名を指定。
  * NATインスタンスを管理しない場合は指定不要。
* `EC2NATInstanceAdminNetwork`
  * NATインスタンスへのSSHログインを行いたい場合、ログイン元を `203.0.113.114/32` のような形式で指定。
  * NATインスタンスを管理しない場合は指定不要。

注：NATインスタンスが置き換えられるとSSHホストキーが変更されます。そのため、SSHコマンドは「WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!」と表示する場合があります。

## Supported regions

このテンプレートは以下のAWSリージョンで動作します：

* ap-northeast-1
* ap-northeast-2
* ap-northeast-3
* ap-south-1
* ap-southeast-1
* ap-southeast-2
* ca-central-1
* eu-central-1
* eu-north-1
* eu-west-1
* eu-west-2
* eu-west-3
* sa-east-1
* us-east-1
* us-east-2
* us-west-1
* us-west-2

## 類似プロジェクト

* [int128/terraform-aws-nat-instance: Terraform module to provision a NAT Instance using an Auto Scaling Group and Spot Instance from $1/month](https://github.com/int128/terraform-aws-nat-instance)
