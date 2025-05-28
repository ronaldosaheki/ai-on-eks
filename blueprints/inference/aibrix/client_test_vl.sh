# Call the server using curl:
curl -X POST "http://${ENDPOINT}/v1/chat/completions" \
	-H "Content-Type: application/json" \
    -H "Authorization: Bearer ${API_KEY}" \
	--data '{
		"model": "qwen25-vl-32b-instruct",
		"messages": [
			{
				"role": "user",
				"content": [
					{
						"type": "text",
						"text": "Describe this image in one sentence."
					},
					{
						"type": "image_url",
						"image_url": {
							"url": "https://cdn.britannica.com/61/93061-050-99147DCE/Statue-of-Liberty-Island-New-York-Bay.jpg"
						}
					}
				]
			}
		]
	}'
