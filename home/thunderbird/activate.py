import hashlib
import json
import sys
import tomllib

with open(sys.argv[1], "rb") as f:
    config = tomllib.load(f)

out = {
    "mail.openpgp.allow_external_gnupg": True,
    "mailnews.default_news_sort_order": 2,
    "mailnews.default_sort_order": 2,
}
accounts = []
servers = []

for acc in config["email"]["accounts"]:
    id = hashlib.sha256(acc["address"].encode()).hexdigest()
    accounts.append(f"account_{id}")

    out[f"mail.account.account_{id}.identities"] = f"id_{id}"
    out[f"mail.account.account_{id}.server"] = f"server_{id}"
    out[f"mail.identity.id_{id}.fullName"] = acc["realName"]
    out[f"mail.identity.id_{id}.useremail"] = acc["address"]
    out[f"mail.identity.id_{id}.valid"] = True

    if acc.get("primary"):
        out["mail.accountmanager.defaultaccount"] = f"account_{id}"

    if gpg := acc.get("gpg"):
        out[f"mail.identity.id_{id}.attachPgpKey"] = True
        out[f"mail.identity.id_{id}.autoEncryptDrafts"] = True
        out[f"mail.identity.id_{id}.e2etechpref"] = 0
        out[f"mail.identity.id_{id}.encryptionpolicy"] = 2
        out[f"mail.identity.id_{id}.is_gnupg_key_id"] = True
        out[f"mail.identity.id_{id}.last_entered_external_gnupg_key_id"] = gpg["key"]
        out[f"mail.identity.id_{id}.openpgp_key_id"] = gpg["key"]
        out[f"mail.identity.id_{id}.protectSubject"] = False
        out[f"mail.identity.id_{id}.sign_mail"] = True

    if imap := acc.get("imap"):
        out[f"mail.server.server_{id}.directory"] = f".thunderbird/default/ImapMail/{id}"
        out[f"mail.server.server_{id}.directory-rel"] = f"[ProfD]ImapMail/{id}"
        out[f"mail.server.server_{id}.hostname"] = imap["host"]
        out[f"mail.server.server_{id}.login_at_startup"] = True
        out[f"mail.server.server_{id}.name"] = acc["address"]
        out[f"mail.server.server_{id}.port"] = imap.get("port", 143)
        out[f"mail.server.server_{id}.socketType"] = 2
        out[f"mail.server.server_{id}.type"] = "imap"
        out[f"mail.server.server_{id}.userName"] = acc["userName"]

    if smtp := acc.get("smtp"):
        servers.append(f"smtp_{id}")
        out[f"mail.identity.id_{id}.smtpServer"] = f"smtp_{id}"
        out[f"mail.smtpserver.smtp_{id}.authMethod"] = 3
        out[f"mail.smtpserver.smtp_{id}.hostname"] = smtp["host"]
        out[f"mail.smtpserver.smtp_{id}.port"] = smtp.get("port", 587)
        out[f"mail.smtpserver.smtp_{id}.try_ssl"] = 2
        out[f"mail.smtpserver.smtp_{id}.username"] = acc["userName"]
        if acc.get("primary"):
            out["mail.smtp.defaultserver"] = f"smtp_{id}"

    if acc["address"].endswith("@gmail.com"):
        out[f"mail.server.server_{id}.authMethod"] = 10
        out[f"mail.smtpserver.smtp_{id}.authMethod"] = 10

out["mail.accountmanager.accounts"] = ",".join(accounts)
out["mail.smtpservers"] = ",".join(servers)

calendars = []
for cal in config["calendars"]:
    id = hashlib.sha256("\n".join([cal["uri"], cal.get("username", ""), cal["name"]]).encode()).hexdigest()
    calendars.append(id)

    for k, v in (
        {"type": "caldav", "readOnly": False, "cache.enabled": True, "calendar-main-in-composite": True} | cal
    ).items():
        out[f"calendar.registry.{id}.{k}"] = v

out |= {
    "calendar.list.sortOrder": " ".join(calendars),
    "calendar.timezone.local": "Europe/Berlin",
    "calendar.view.visiblehours": 16,
    "calendar.week.start": 1,
}

for k, v in out.items():
    print(f'user_pref("{k}", {json.dumps(v)});')
