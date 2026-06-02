"use client";

import { useEffect, useState } from "react";

export default function Home() {
  const [messages, setMessages] = useState([]);
  const [text, setText] = useState("");

  const fetchMessages = async () => {
    try {
      const response = await fetch(
        "/api/messages"
      );

      const data = await response.json();

      setMessages(data);
    } catch (error) {
      console.error("Failed to fetch messages:", error);
    }
  };

  useEffect(() => {
    fetchMessages();
  }, []);

  const sendMessage = async () => {
    if (!text.trim()) return;

    try {
      await fetch("/api/messages", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          text,
        }),
      });

      setText("");

      fetchMessages();
    } catch (error) {
      console.error("Failed to send message:", error);
    }
  };

  return (
    <main className="min-h-screen p-10">
      <div className="max-w-xl mx-auto">
        <h1 className="text-3xl font-bold mb-6">
          Messages App
        </h1>

        <div className="flex gap-2 mb-6">
          <input
            type="text"
            value={text}
            onChange={(e) => setText(e.target.value)}
            placeholder="Enter message..."
            className="border p-2 flex-1 rounded"
          />

          <button
            onClick={sendMessage}
            className="bg-black text-white px-4 rounded"
          >
            Send
          </button>
        </div>

        <div className="space-y-2">
          {messages.map((message) => (
            <div
              key={message.id}
              className="border p-3 rounded"
            >
              {message.text}
            </div>
          ))}
        </div>
      </div>
    </main>
  );
}