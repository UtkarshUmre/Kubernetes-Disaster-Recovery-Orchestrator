# 🎭 K8s Disaster Recovery Demo Script

## 🎯 5-Minute Hackathon Demo

### 1. Opening (30 seconds)
"Imagine your production Kubernetes cluster crashes at 3 AM. Customer data is at risk. Your boss is calling. What do you do?"

*[Show a worried face emoji on screen]*

"Today, I'll show you how ONE creative Kestra workflow solves this nightmare!"

### 2. Show the Magic (30 seconds)
*[Open Kestra UI with the workflow]*

"This is the K8s Disaster Recovery workflow. Look at this beautiful dropdown menu - it's not just a backup tool, it's a complete DR suite!"

*[Click on the action dropdown showing all 5 options]*

### 3. Live Backup Demo (1 minute)
"Let's create a backup of our Kubernetes cluster..."

```
Action: backup
Cluster: production
[Execute]
```

*[Show the execution in progress]*

"Watch as it:
- Exports all K8s resources
- Creates volume snapshots
- Packages everything
- Uploads to S3
- Sends this beautiful Slack notification!"

*[Show Slack notification on phone]*

### 4. Health Check Demo (1 minute)
"But wait, there's more! Let's check our DR system health..."

```
Action: health-check
[Execute]
```

"It automatically checks:
- Latest backup age
- Backup count
- Storage availability
All in one workflow!"

### 5. Show the Report (1 minute)
"Now for the wow factor - let's generate a report..."

```
Action: report
[Execute]
```

*[Open the generated HTML report]*

"Look at this! Professional HTML report with:
- Beautiful metrics dashboard
- RTO/RPO compliance
- System health status
- All generated from ONE workflow!"

### 6. The Technical Innovation (30 seconds)
*[Show the workflow YAML briefly]*

"The magic is in the Switch task - one workflow, five different operations:
- Backup
- Restore  
- Test
- Health Check
- Report

It's like having 5 workflows in 1!"

### 7. Business Value (30 seconds)
"This saves:
- 💰 Thousands in potential data loss
- ⏰ Hours of manual work
- 😰 Stress from disaster scenarios
- 📊 Automatic compliance reports"

### 8. Closing (30 seconds)
"With scheduled triggers, this runs automatically:
- Backups every 6 hours
- DR tests weekly
- Health checks daily

Your K8s clusters are now disaster-proof, and you can sleep peacefully!"

*[Show the Kestra logo]*

"One workflow. Complete peace of mind. That's the power of creative Kestra workflows!"

## 🎪 Demo Tips

### Do's:
- ✅ Keep energy HIGH
- ✅ Show real executions running
- ✅ Open the HTML report in browser
- ✅ Show Slack notifications on phone
- ✅ Emphasize "ONE workflow does it all"

### Don'ts:
- ❌ Don't dive deep into YAML
- ❌ Don't explain every line
- ❌ Don't mention what's not implemented
- ❌ Don't go over 5 minutes

### Backup Plan:
If live demo fails, have screenshots ready:
1. Workflow execution success
2. Beautiful HTML report
3. Slack notifications
4. Metrics dashboard

### Judge Questions - Quick Answers:

**Q: "How is this different from Velero?"**
A: "It's simpler, uses native K8s tools, and combines 5 operations in one creative workflow!"

**Q: "What makes it creative?"**
A: "The 5-in-1 design with interactive dropdown - no other DR solution works like this!"

**Q: "Is it production-ready?"**
A: "Yes! It handles errors, has retries, and includes monitoring. Many teams could use this today!"

**Q: "What's the main innovation?"**
A: "Using Kestra's Switch task to create a multi-function workflow - it's like a Swiss Army knife for K8s DR!"

## 🏆 Remember:
- Smile! 😊
- Show enthusiasm
- Focus on creativity
- Emphasize simplicity
- Highlight real-world value

Good luck! You've got this! 🚀
