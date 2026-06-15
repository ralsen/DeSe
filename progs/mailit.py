import smtplib, ssl
import logging
import threading
from email.message import EmailMessage


logger = logging.getLogger(__name__)

class MailIt:
    """
    The BuildGraph class is used to create and manage graphs for monitoring data.
    It initializes the graph with a given node and provides methods to build the graph.
    """
    def __init__(self, cfg):
        """
        The function initializes a BuildGraph object with a given Node.
        """
        self.cfg = cfg


    def mailit(self, subject: str, text: str):
        """
        The `mailit` function sends an email with a specified subject and text using the SMTP protocol.
        
        :param subject: The subject of the email that you want to send
        :type subject: str
        :param text: The `text` parameter is a string that represents the body of the email message. It can
        contain any text or HTML content that you want to include in the email
        :type text: str
        """
        if self.cfg['Mailing']:
            threading.Thread(target=self._mailit_thread, args=(subject, text), daemon=True).start()

    def _mailit_thread(self, subject: str, text: str):
        mail_user = "follrichs@gmx.de"
        mail_pwd = "qiwvi0-nYvtis-pyvtes"
        msg = EmailMessage()
        msg["Subject"] = subject
        msg["From"] = mail_user
        msg["To"] = "follrichs@icloud.com"
        msg.set_content(text)
        context = ssl.create_default_context()

        with smtplib.SMTP("mail.gmx.net", 587) as smtp:
            smtp.set_debuglevel(1)
            smtp.starttls(context=context)
            smtp.login(mail_user, mail_pwd)
            smtp.send_message(msg)        
        logger.info(f"Mailing to: {msg['To']}; Subject: {subject}; content: {text}")
        