FROM node:16-alpine AS build
ENV NODE_ENV=development
ENV DISTDIR=/usr/local/share/graphql-inspector

WORKDIR /app

COPY . .

RUN yarn install
RUN yarn build

FROM node:16-alpine AS dist
ENV NODE_ENV=production

COPY --from=build /app/packages "${DISTDIR}"/packages
COPY --from=build /app/package.json ${DISTDIR}

RUN mkdir /app
WORKDIR /app

RUN cd ${DISTDIR} \
  && yarn install \
  && yarn cache clean \
  && ln -s "${DISTDIR}"/packages/cli/dist/index.js /usr/local/bin/graphql-inspector \
  && chmod +x /usr/local/bin/graphql-inspector
