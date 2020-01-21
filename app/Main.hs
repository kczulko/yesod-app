{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE UndecidableInstances #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE EmptyDataDecls             #-}
{-# LANGUAGE FlexibleContexts           #-}
{-# LANGUAGE GADTs                      #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses      #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE TemplateHaskell   #-}
{-# LANGUAGE TypeFamilies      #-}
{-# LANGUAGE DeriveGeneric     #-}

module Main where

import GHC.Generics
import Data.Text
import Data.Aeson
import Yesod

share [mkPersist sqlSettings, mkMigrate "migrateAll"] [persistLowerCase|
EmailMessage
    title String
    body String
    deriving Show
|]
instance Generic EmailMessage

data HelloWorld = HelloWorld

--data EmailMessage = EmailMessage {
--    title :: Text,
--    body  :: Text
--  } deriving (Generic, Show, Eq)

instance ToJSON EmailMessage
instance FromJSON EmailMessage

mkYesod "HelloWorld" [parseRoutes|
/ HomeR GET
/sendmail SendMailR POST
|]

instance Yesod HelloWorld

getHomeR :: Handler Text
getHomeR = return "Hello, World!"

postSendMailR :: Handler Text
postSendMailR = do
 msg <- requireCheckJsonBody :: Handler EmailMessage
 return $ pack . show $ msg

main :: IO ()
main = warp 3000 HelloWorld
