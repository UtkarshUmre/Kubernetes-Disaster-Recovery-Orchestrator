# 🚀 K8s Disaster Recovery - Creative Kestra Workflow

A **single, powerful Kestra workflow** that provides complete Kubernetes disaster recovery capabilities with an elegant design.

## 🌟 What Makes This Creative?

This innovative workflow combines **5 different DR operations** into one smart workflow using Kestra's Switch task:
- 🔄 **Automated Backups** with CSI snapshots
- 🚨 **Instant Restore** from any backup
- 🧪 **DR Testing** with RTO metrics
- 🏥 **Health Monitoring** with alerts
- 📊 **Beautiful Reports** in HTML

All controlled by a simple dropdown menu!

## 🎯 Perfect for Hackathon Because:

1. **Single File Simplicity** - Everything in one workflow file
2. **Interactive UI** - Users select actions from dropdown
3. **Visual Appeal** - Generates beautiful HTML reports and rich Slack messages
4. **Real-World Value** - Solves critical K8s DR problem
5. **Technical Innovation** - Shows advanced Kestra features

## 🚀 Quick Start

### 1. Prerequisites
- Google Cloud account with billing enabled
- gcloud CLI installed
- A GCP project (we'll create everything else!)
- Slack webhook (optional)

### 2. Complete Setup on Google Cloud
Follow the comprehensive guide in `GCP-SETUP-GUIDE.md` which will help you:
- Create a GKE cluster
- Deploy Kestra on Cloud Run (serverless!)
- Set up Google Cloud Storage
- Configure all secrets automatically

```bash
# Quick start after GCP setup:
./setup-kestra-secrets.sh
```

### 3. Deploy the Workflow
Simply upload `k8s-disaster-recovery.yml` to Kestra!

## 💡 How to Use

### Manual Execution
1. Go to Kestra UI
2. Select the workflow
3. Choose an action from dropdown:
   - `backup` - Create a backup
   - `restore` - Restore from backup
   - `test` - Run DR test
   - `health-check` - Check system health
   - `report` - Generate HTML report

### Automated Execution
The workflow includes triggers for:
- Backups every 6 hours
- Weekly DR tests
- Daily health checks

## 📊 Example Output

### Beautiful HTML Report
The workflow generates stunning reports with inline CSS showing:
- RTO/RPO metrics
- System health status
- Backup statistics
- Trend analysis

### Rich Slack Notifications
Get instant updates with formatted messages showing backup status, test results, and alerts.

## 🏆 Why This Wins

1. **Solves Real Problem** - Every K8s user needs DR
2. **Technical Excellence** - Shows mastery of Kestra features
3. **User-Friendly** - Anyone can use it with the dropdown
4. **Production-Ready** - Actually works in real environments
5. **Creative Design** - Single workflow doing 5 different jobs

## 🎨 Customization

Edit the workflow to:
- Change storage backend (S3 → GCS/Azure)
- Adjust backup frequency
- Modify report styling
- Add more health checks
- Include custom notifications

## 📝 Workflow Structure

```yaml
inputs:
  - name: action
    type: SELECT  # Creative dropdown menu!
    values: [backup, restore, test, health-check, report]

tasks:
  - id: action-router
    type: Switch  # Smart routing based on selection
    cases:
      backup: [...]
      restore: [...]
      test: [...]
      health-check: [...]
      report: [...]
```

## 🚨 Demo Script for Judges

1. **Show the Problem**: "K8s disasters happen - data loss is costly"
2. **Present Solution**: "One workflow handles everything"
3. **Live Demo**: 
   - Create a backup
   - Show health check
   - Generate beautiful report
4. **Highlight Innovation**: "5-in-1 design with interactive UI"
5. **Business Value**: "Saves hours of manual work, prevents data loss"

---

**Built for Kestra Hackathon** 🏆 Good luck!
