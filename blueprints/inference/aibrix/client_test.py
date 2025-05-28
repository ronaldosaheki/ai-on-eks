from openai import OpenAI
import os

ENDPOINT=os.getenv("ENDPOINT","localhost:8888")
client = OpenAI(base_url=f"http://{ENDPOINT}/v1", api_key="OPENAI_API_KEY",
                                default_headers={'routing-strategy': 'least-request'})

completion = client.chat.completions.create(
        model="deepseek-r1-distill-llama-8b",
    messages=[
                {"role": "system", "content": "You are a helpful assistant."},
                {"role": "user", "content": "What is the capital of California?"}

    ]

)
print(completion.choices[0].message.content)
