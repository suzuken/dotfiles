# GAS 範囲限定共有のデプロイ (justfile 断片)。ビルド済み配布物を scripts/gas/ に集めて clasp で配信。
# 前提: 静的サイトのビルドが `dist/` に単一ファイル群を出すこと (build ターゲットは各プロジェクト依存)。
#       初回セットアップ (clasp login / create / deploymentId 固定) は references/setup.md 参照。

# GAS Web アプリに配信 (範囲限定: 組織ドメイン + allowlist)。URL 不変で中身を更新する。
deploy-gas: build
    cp dist/index.html scripts/gas/index.html
    # ↓ ページ間リンクを iframe サンドボックス対応のプレースホルダに置換 (ルートごとに 1 行)。
    #   HTML 側で href="page1/index.html" のように書いておき、__P_PAGE1__ + target="_top" に変換。
    #   単一ページなら以下の sed 行は不要。
    # sed -i '' 's#href="page1/index.html"#href="__P_PAGE1__" target="_top"#g' scripts/gas/index.html
    # cp dist/page1.html scripts/gas/page1.html
    pnpm exec clasp push -f
    # ★ 固定 deployment を更新 (URL 不変)。<DEPLOYMENT_ID> は初回 deploy で発行された ID に置換。
    pnpm exec clasp redeploy <DEPLOYMENT_ID> -d "deploy via just deploy-gas"

# ローカル確認 (GAS に上げる前に dist を素の HTTP で見る。__P_* は GAS でのみ置換される点に注意)
preview: build
    cd dist && python3 -m http.server 8765 --bind 127.0.0.1
