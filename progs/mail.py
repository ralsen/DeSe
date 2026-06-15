import smtplib

import ssl

from email.message import EmailMessage

mail_user = "follrichs@gmx.de"
mail_pwd = "qiwvi0-nYvtis-pyvtes"
msg = EmailMessage()
msg["Subject"] = "test mail"
msg["From"] = mail_user
msg["To"] = "follrichs@icloud.com"
msg.set_content("this is a test mail from python")
context = ssl.create_default_context()

with smtplib.SMTP("mail.gmx.net", 587) as smtp:
    smtp.set_debuglevel(1)
    smtp.starttls(context=context)
    smtp.login(mail_user, mail_pwd)
    smtp.send_message(msg)