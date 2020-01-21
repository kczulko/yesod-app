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

data HelloWorld = HelloWorld

mkYesod "HelloWorld" [parseRoutes|
/sendmail SendMailR POST
|]

instance Yesod HelloWorld

postSendMailR :: Handler Text
postSendMailR = (pack . show) <$> (requireCheckJsonBody :: Handler EmailMessage)

main :: IO ()
main = warp 3000 HelloWorld
