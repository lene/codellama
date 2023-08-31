# Copyright (c) Meta Platforms, Inc. and affiliates.
# This software may be used and distributed according to the terms of the Llama 2 Community License Agreement.

from time import time
from typing import Optional

import fire
import torch.cuda

from llama import Llama


def main(
        ckpt_dir: str,
        tokenizer_path: str,
        temperature: float = 0.2,
        top_p: float = 0.95,
        max_seq_len: int = 512,
        max_batch_size: int = 8,
        max_gen_len: Optional[int] = None,
        language: str = 'Python',
        prompt: str = ''
):
    generator = Llama.build(
        ckpt_dir=ckpt_dir,
        tokenizer_path=tokenizer_path,
        max_seq_len=max_seq_len,
        max_batch_size=max_batch_size,
    )

    while prompt != 'exit':
        prompt = input(f'Enter a task to be solved in {language} ("exit" to exit): ')
        instructions = [
            [
                {
                    "role": "system",
                    "content": f"Provide answers in {language}",
                },
                {
                    "role": "user",
                    "content": prompt,
                }
            ],
        ]
        start_time = time()
        start = torch.cuda.Event(enable_timing=True)
        end = torch.cuda.Event(enable_timing=True)
        start.record()

        results = generator.chat_completion(
            instructions,  # type: ignore
            max_gen_len=max_gen_len,
            temperature=temperature,
            top_p=top_p,
        )
        end.record()

        for instruction, result in zip(instructions, results):
            for msg in instruction:
                print(f"{msg['role'].capitalize()}: {msg['content']}\n")
            print(
                f"> {result['generation']['role'].capitalize()}: {result['generation']['content']}"
            )
            print("\n==================================\n")
        print(
            f'''
    Answered in {time() - start_time:.2f}s, {start.elapsed_time(end) / 1000:.2f}s in torch 
    with {torch.cuda.utilization()}% GPU utilization.'''
        )


if __name__ == "__main__":
    fire.Fire(main)
