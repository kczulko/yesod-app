{-# LANGUAGE DerivingStrategies         #-}
{-# LANGUAGE UndecidableInstances       #-}
{-# LANGUAGE StandaloneDeriving         #-}
{-# LANGUAGE EmptyDataDecls             #-}
{-# LANGUAGE FlexibleContexts           #-}
{-# LANGUAGE FlexibleInstances          #-}
{-# LANGUAGE GADTs                      #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses      #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE QuasiQuotes                #-}
{-# LANGUAGE TemplateHaskell            #-}
{-# LANGUAGE TypeFamilies               #-}
{-# LANGUAGE DeriveGeneric              #-}

module Main where

import GHC.Generics
import Data.Text
import Data.Aeson
import Control.Monad.Logger(runStderrLoggingT)
import Control.Monad.Trans.Resource (runResourceT)
import Yesod
import Database.Persist
import Database.Persist.Postgresql
import Database.Persist.TH

share [mkPersist sqlSettings, mkMigrate "migrateAll"] [persistLowerCase|
EmailMessage json
    title String
    body String
    deriving Show
|]

data HelloWorld = HelloWorld ConnectionPool
instance Yesod HelloWorld
instance YesodPersist HelloWorld where
  type YesodPersistBackend HelloWorld = SqlBackend
  runDB action = do
    HelloWorld pool <- getYesod
    runSqlPool action pool

mkYesod "HelloWorld" [parseRoutes|
/sendmail SendMailR POST
|]

postSendMailR :: Handler Text
postSendMailR = do
  token <- lookupBearerAuth
  liftIO $ print token
  emailMsg <- requireCheckJsonBody :: Handler EmailMessage
  value <- runDB $ insert emailMsg
  return $ pack . show $ emailMsg

connStr = "host=0.0.0.0 dbname=test user=test password=test port=5432"

main :: IO ()
main = runStderrLoggingT $ withPostgresqlPool connStr 10 $ \pool -> liftIO $ do
    runResourceT $ flip runSqlPool pool $ do
      runMigration migrateAll
    warp 3000 $ HelloWorld pool

