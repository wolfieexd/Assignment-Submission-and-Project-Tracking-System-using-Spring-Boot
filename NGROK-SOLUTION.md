# NGROK RESERVED DOMAIN - DEPLOYMENT SOLUTION

## Current Situation:
- You have 1 reserved domain on ngrok free tier: `unflickeringly-mouldier-harmony.ngrok-free.dev`
- This domain is automatically assigned to the FIRST tunnel you start
- You can only use 1 reserved domain on free tier

## ✅ RECOMMENDED SOLUTION:

### Option A: Use Reserved Domain + Random URL (EASIEST)
1. **User Service**: Uses your reserved domain (won't change)
   - URL: `https://unflickeringly-mouldier-harmony.ngrok-free.dev`
   - Port: 8081
   
2. **Submission Service**: Uses random URL (changes on restart)
   - Start tunnel AFTER user service is running
   - Check ngrok dashboard for the random URL

### Option B: Delete Reserved Domain (Use Random URLs for Both)
1. Go to: https://dashboard.ngrok.com/cloud-edge/domains
2. Delete domain: `unflickeringly-mouldier-harmony`
3. Restart both tunnels - both will get random URLs

### Option C: Upgrade ngrok (Paid - $8/month)
- Get multiple reserved domains
- Static URLs that never change
- Better for production

## 🚀 QUICK START (Option A):

```powershell
# Terminal 1 - User Service (uses reserved domain automatically)
ngrok http 8081

# Terminal 2 - Submission Service (gets random URL)  
# Wait 5 seconds after starting User Service, then:
ngrok http 8082
```

Then check: http://localhost:4040 and http://localhost:4041 for the URLs

## 📝 For Vercel Deployment:

Use these environment variables:
```
VITE_API_URL=https://unflickeringly-mouldier-harmony.ngrok-free.dev/api
VITE_SUBMISSION_API_URL=https://[RANDOM-URL-FROM-SECOND-TUNNEL].ngrok-free.app/api
```

⚠️ **NOTE**: The random URL for Submission Service will change every time you restart ngrok!

To get a permanent solution, delete the reserved domain and both will use random URLs, OR upgrade to ngrok paid plan.
