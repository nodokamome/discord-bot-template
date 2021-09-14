# ----------
# build(tscを実行してjsを作る)用のstage
# ----------
FROM node:14 AS build

WORKDIR /build
COPY . .
RUN npm install
RUN npm run build

# ----------
# runtime用のstage
# 必要なファイルは
#   dist/
#   node_modules/
#   package.json
#   package-lock.json
# のみ
# ----------

FROM node:14

WORKDIR /usr/src/app

COPY package*.json ./

# ランタイムに必要な依存パッケージのみインストールし、同時にnpmのcacheファイルを削除する
RUN npm install --production --cache /tmp/empty-cache && rm -rf /tmp/empty-cache

ENV TZ=Asia/Tokyo

# --fromで前半で記述したAS buildと命名した中間イメージから必要なファイルのみ抽出する事ができる(distディレクトリにtsコンパイル結果であるjsファイルが出力されている)
COPY --from=build /build/dist ./dist

CMD [ "npm", "start" ]
