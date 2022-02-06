# QuranAudioPlayerKit

- Stream Play and Donwload Quran Audio Based on the Data.json
- Data.json format

``
{
    "baseUrl": "<Audio Base Url>",
    "shareText":"App Share Text",
    "mail": {
        "subject": "<App Mail Subject>",
        "to": ["email2","email2"]
    },
    "chapters": [
        {
            "index": 1,
            "name": "ٱلْفَاتِحَة",
            "nameTrans": "Al-Fatihah",
            "fileName": "<filenname>",
            "size": "<size>",
            "durationInSecs": <duaration in Int>
        }
    ]
}
``
