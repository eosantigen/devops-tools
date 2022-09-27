#!/usr/bin/env python3

import json
import time
import os
from slack_sdk.webhook import WebhookClient
from fastapi import FastAPI, Request

serve = FastAPI()

@serve.post("/")
async def awesome_post_request(request: Request):

  received_payload = json.dumps(await request.json())
  event = json.loads(received_payload)

  event_timestamp = time.strftime("%c, %Z")

  if "from_client_id" in event.keys():
    awesome_slack_payload = str(
      "Data:\n------------\n"
      + event['payload'] + "\n"
      + "Time: " + event_timestamp)
    await slack_send(awesome_slack_payload)

async def slack_send(awesome_slack_payload: str):

  webhook_url = os.environ['WEB_HOOK_SLACK_TOKEN']
  webhook = WebhookClient(webhook_url)
  webhook.send(text = awesome_slack_payload)