import matplotlib.pyplot as plt

timestamps = []
memory_usage = []

with open('chart.data', 'r') as file:
    for line in file:
        parts = line.split()
        timestamps.append(parts[0] + ' ' + parts[1])
        memory_usage.append([
            float(parts[2][:-2]),
            float(parts[3][:-2]),
            float(parts[4][:-2]),
            float(parts[5][:-2]),
            float(parts[6][:-2]),
            float(parts[7][:-2]),
        ])

total, used, free, shared, buff_cache, available = zip(*memory_usage)

plt.figure(figsize=(10, 6))

plt.plot(timestamps, total, label='Total (Gi)', marker='o')
plt.plot(timestamps, used, label='Used (Gi)', marker='o')
plt.plot(timestamps, free, label='Free (Gi)', marker='o')
# plt.plot(timestamps, shared, label='Shared (Mi)', marker='o')
plt.plot(timestamps, buff_cache, label='Buff/Cache (Gi)', marker='o')
plt.plot(timestamps, available, label='Available (Gi)', marker='o')

plt.xlabel('Timestamp')
plt.ylabel('Memory Usage (Gi)')
plt.title('Memory Usage Over Time')
plt.xticks(rotation=45, ha='right')
plt.tight_layout()
plt.legend()
plt.grid(True)

plt.show()
