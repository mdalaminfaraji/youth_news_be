module.exports = {
  apps: [
    {
      name: "youth-media",
      script: "src/index.js",
      instances: "max",
      autorestart: true,
      watch: false,
      max_memory_restart: "1G",
      env: {
        NODE_ENV: "production",
      },
    },
  ],
};
