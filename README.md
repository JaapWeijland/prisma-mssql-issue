# Introduction

Hello there,

This repo is a reproduction of an issue we had when using SQL Server with Prisma. The error we try to reproduce is the following error:

```
Error occurred during query execution:
ConnectorError(ConnectorError { user_facing_error: None, kind: QueryError(TokenError { code: 8003, state: 1, class: 16, message: "The incoming request has too many parameters. The server supports a maximum of 2100 parameters. Reduce the number of parameters and resend the request.", server: "7f1435c2142c", procedure: "", line: 1 }), transient: false })
    at Pn.handleRequestError (/Users/weijland/Documents/Work/NAVARA/prisma-mssql/node_modules/@prisma/client/runtime/library.js:171:7103)
    at Pn.handleAndLogRequestError (/Users/weijland/Documents/Work/NAVARA/prisma-mssql/node_modules/@prisma/client/runtime/library.js:171:6358)
    at Pn.request (/Users/weijland/Documents/Work/NAVARA/prisma-mssql/node_modules/@prisma/client/runtime/library.js:171:6237) {
  clientVersion: '4.14.1'
}
```

This error occurs when trying to update multiple models at once. In this reproduction, we created 1 `door` with 10.000 `addOns` connected to it. Then we try to delete all relations at once with the follwing command:

```
await prisma.door.update({
    where: { id: "door-1" },
    data: { addOns: { set: [] } },
});
```

This throws the error mentioned above.

# Usage

- Download the mssql Docker image: `docker pull mcr.microsoft.com/mssql/server`
- Spin up a local sqlserver instance with Docker: `docker run -e "ACCEPT_EULA=1" -e "MSSQL_SA_PASSWORD=Some Very Strong Password 123" -e "MSSQL_PID=Developer" -e "MSSQL_USER=SA" -p 1433:1433 -d --name=prisma-mssql mcr.microsoft.com/mssql/server`
- Connect to the database by creating a `.env` file containing the following variables:

```
DATABASE_URL="sqlserver://127.0.0.1:1433;database=prisma-mssql;user=sa;password=Some Very Strong Password 123;encrypt=DANGER_PLAINTEXT;connection_limit=128;pool_timeout=0;"
SHADOW_DATABASE_URL="sqlserver://127.0.0.1:1433;database=prisma-mssql-shadow;user=sa;password=Some Very Strong Password 123;encrypt=DANGER_PLAINTEXT;connection_limit=128;pool_timeout=0;"
```

- Run `npm i`
- Run `npx prisma migrate deploy`
- Run `npm start`
