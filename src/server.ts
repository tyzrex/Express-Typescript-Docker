import bodyParser from "body-parser";
import cors from "cors";
import dotenv from "dotenv";
import express, { Request, Response } from "express";

import routes from "./routes";
dotenv.config();

const app = express();
app.use(
  cors({
    origin: process.env.CLIENT_URL,
    credentials: true,
    optionsSuccessStatus: 200, // some legacy browsers (IE11, various SmartTVs) choke on 204
  })
);
app.use(bodyParser.json());

app.use(routes);

app.get("/", (req: Request, res: Response) => {
  res.send("Hello World!");
});

const port = process.env.PORT;
app.listen(port, () => {
  console.log(`
  |=============================================|
    🖇️Server listening at http://localhost:${port} 🖇️
  |=============================================|
  `);
});
