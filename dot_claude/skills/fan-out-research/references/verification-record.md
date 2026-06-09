# 検証記録の型

claim ごとに次を構造化して残す。執筆時にそのまま論拠として引ける形にする。JSON で持つと資料生成・再検証に再利用できる。

## フィールド
- `claim` — 検証可能な一文 (データで真偽を問える形)
- `decision` — どの決定項目の根拠か (decision-deck-architecture の N に対応)
- `verdict` — `supported` / `refuted` / `caveat`
- `confidence` — high / medium / low (verifier の一致度)
- `evidence` — 判定の根拠 (数値・事実)
- `caveat` — 条件付きの場合の条件 (例:「日本市場では 1-3 年遅れる」)
- `sources` — 出典 URL の配列 (生存確認済)

## JSON 例
```json
{
  "central_thesis": "代理業務は AI で代替され、上流のパートナーシップに価値が移る",
  "verified_at": "YYYY-MM-DD",
  "claims": [
    {
      "claim": "過去5年で大手代理店グループの当該市場シェアは縮小した",
      "decision": "事業の再ポジショニングをやるか",
      "verdict": "supported",
      "confidence": "high",
      "evidence": "主要N社の合算シェアが XX% → YY% に低下 (3 verifier 一致)",
      "caveat": null,
      "sources": ["https://...", "https://..."]
    },
    {
      "claim": "上流に移った competitor はシェアを回復した",
      "decision": "事業の再ポジショニングをやるか",
      "verdict": "refuted",
      "confidence": "medium",
      "evidence": "リポジショニング後もシェア無回復の事例が多数。回復は確認できず",
      "caveat": null,
      "sources": ["https://..."]
    },
    {
      "claim": "この投資のペイバックは3年以内",
      "decision": "新規投資を承認するか",
      "verdict": "caveat",
      "confidence": "low",
      "evidence": "業界平均ペイバックは2-4年。前提次第で振れる",
      "caveat": "稼働率がXX%を超える前提。下回ると4年超",
      "sources": ["https://..."]
    }
  ]
}
```

## 執筆への渡し方
- `supported` のみ本文の断定文にできる。
- `refuted` は本文から外す (または「これは確認できなかった」と明示)。
- `caveat` は条件を併記する (「○○の前提で」)。
- 各断定文に出典を紐付け、資料の脚注・参照リストにそのまま使う。
