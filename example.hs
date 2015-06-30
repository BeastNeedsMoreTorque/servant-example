{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module Main where

import Control.Monad.Trans.Either   (EitherT)
import Network.Wai                  (Application)
import Network.Wai.Handler.Warp     (run)
import Network.Wai.Middleware.RequestLogger (logStdoutDev)
import Servant
    ( (:>), (:<|>)((:<|>)), Get, JSON, Proxy(..), ServantErr, ServerT, serve )

type MyAPI = "dogs" :> Get '[JSON] [Int]
        :<|> "cats" :> Get '[JSON] [String]

app :: Application
app = serve userAPI server
  where
    userAPI :: Proxy MyAPI
    userAPI = Proxy

server :: ServerT MyAPI (EitherT ServantErr IO)
server = dogNums :<|> cats

dogNums :: EitherT ServantErr IO [Int]
dogNums = return [1,2,3,4]

cats :: EitherT ServantErr IO [String]
cats = return ["long-haired", "short-haired"]

main :: IO ()
main = run 32323 $ logStdoutDev app
