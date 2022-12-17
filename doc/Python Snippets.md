```python
expiry_time = datetime.datetime.fromtimestamp(token_decoded.get('exp')).strftime('%m %d %H %M')

formated_expiry_time = time.strptime(expiry_time, "%m %d %H %M") # this returns a struct from which values i.e. minute can be extracted separately.

now = time.localtime(time.time())

hours_to_expiry = abs(formated_expiry_time.tm_hour - now.tm_hour)

if (now.tm_mday == formated_expiry_time.tm_mday and hours_to_expiry<10):
	await handler.stop_single_user(user, user.spawner.name)
	handler.clear_cookie("jupyterhub-hub-login")
	handler.clear_cookie("jupyterhub-session-id")
else:
	pass
```