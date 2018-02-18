module Tos exposing (Section, tos)


type alias Section =
    { title : String
    , content : String
    , list : List String
    }


tos : List Section
tos =
    [ { title = "Definitions"
      , content = definitionsContent
      , list = []
      }
    , { title = "Terms"
      , content = termsContent
      , list = []
      }
    , { title = "Disclaimer"
      , content = disclaimerContent
      , list = []
      }
    , { title = "Limitations"
      , content = limitationsContent
      , list = []
      }
    , { title = "Privacy"
      , content = privacyContent
      , list = privacyList
      }
    ]


definitionsContent : String
definitionsContent =
    "Chad \"Chadtech\" Stearns, CEO of Chadtech Corporation, an S Corp of New York State, herein will be referred to as \"Chadtech\"."


termsContent : String
termsContent =
    "By accessing the CtPaint website, you are agreeing to be bound by these terms and conditions of use, all applicable laws and regulations, and agree that you are responsible for compliance with those those laws and regulations. If you do not agree with any of these terms, you are prohibited from using this site."


disclaimerContent : String
disclaimerContent =
    "The material on this website are provided \"as is\". Chadtech makes no warranties, expressed or implied, and hereby disclaims and negates all other warranties, including without limitation, implied warranties or conditions of merchantability, fitness for a particular purpose, or non-infringement of intellectual property or other violation of rights. Further, Chadtech does not warrant or make any representations concerning the accuracy, likely results, or reliability of the use of the materials on its Internet web site or otherwise relating to such materials or on any sites linked to this site."


limitationsContent : String
limitationsContent =
    "In no event shall Chadtech or its suppliers be liable for any damages (including, without limitation, damages for loss of data or profit, or due to business interruption,) arising out of the use or inability to use the materials on Chadtech's Internet site, even if Chadtech has been notified orally or in writing of the possibility of such damage. Because some jurisdictions do not allow limitations on implied warranties, or limitations of liability for consequential or incidental damages, these limitations may not apply to you."


privacyContent : String
privacyContent =
    "User privacy is important to Chadtech. The privacy policy below describes how Chadtech handles your private and identifying inofmration."


privacyList : List String
privacyList =
    [ "CtPaint is developed using Amazon Web Services. All authentication is done using Amazon Web Services, and the best practices for using it. All user data is stored at Amazon through Amazon Web Services"
    , "Chadtech does not store your password and does not know what it is. Chadtech cannot access your password from your user data on the Amazon Web Services servers. During log in, passwords are cleared from memory immediately after the user attempts to log in."
    , "Chadtech will never give out user identifying or personal information without the consent of the identified users, unless compelled to by law."
    , "Chadtech may look at your email address and may email you."
    , "Chadtech may look at user data in an anonymized and aggregated way. Anonymizing user data means removing information that could be used to discover the identity of the user, such as emails, profile bios, usernames, user ids, and image data."
    , "Chadtech will never look at private user data without the permission of the user. Private user data in this context, means data only the user could access through the normal operation of CtPaint. Private images would be an example."
    , "All drawings on CtPaint, except private drawings, which are only accessible to the silver subscription tier, are publicly accessible. This means that anyone with the corresponding url could access it."
    ]
