import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Privacy Policy for SUSU',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'At SUSU, one of our main priorities is the privacy of our visitors. This Privacy Policy document contains types of information that is collected and recorded by SUSU and how we use it.',
              ),
              const SizedBox(height: 8),
              const Text(
                'If you have additional questions or require more information about our Privacy Policy, do not hesitate to contact us.',
              ),
              const SizedBox(height: 16),
              const Text(
                'Log Files',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'SUSU follows a standard procedure of using log files. These files log visitors when they use the app. The information collected by log files includes internet protocol (IP) addresses, browser type, Internet Service Provider (ISP), date and time stamp, referring/exit pages, and possibly the number of clicks. These are not linked to any information that is personally identifiable. The purpose of the information is for analyzing trends, administering the app, tracking users\' movement on the app, and gathering demographic information.',
              ),
              const SizedBox(height: 16),
              const Text(
                'Our Advertising Partners',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Some of advertisers in our app may use cookies and web beacons. Our advertising partners are listed below. Each of our advertising partners has their own Privacy Policy for their policies on user data. For easier access, we hyperlinked to their Privacy Policies below.',
              ),
              const SizedBox(height: 8),
              ListTile(
                title: const Text('Google'),
                subtitle:
                    const Text('https://policies.google.com/technologies/ads'),
                onTap: () {
                  // Open the URL
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Privacy Policies',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'You may consult this list to find the Privacy Policy for each of the advertising partners of SUSU.',
              ),
              const SizedBox(height: 8),
              const Text(
                'Third-party ad servers or ad networks use technologies like cookies, JavaScript, or Beacons that are used in their respective advertisements and links that appear on SUSU. They automatically receive your IP address when this occurs. These technologies are used to measure the effectiveness of their advertising campaigns and/or to personalize the advertising content that you see on this app or other apps or websites.',
              ),
              const SizedBox(height: 8),
              const Text(
                'Note that SUSU has no access to or control over these cookies that are used by third-party advertisers.',
              ),
              const SizedBox(height: 16),
              const Text(
                'Third Party Privacy Policies',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'SUSU\'s Privacy Policy does not apply to other advertisers or websites. Thus, we are advising you to consult the respective Privacy Policies of these third-party ad servers for more detailed information. It may include their practices and instructions about how to opt-out of certain options.',
              ),
              const SizedBox(height: 16),
              const Text(
                "Children's Information",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Another part of our priority is adding protection for children while using the internet. We encourage parents and guardians to observe, participate in, and/or monitor and guide their online activity.',
              ),
              const SizedBox(height: 8),
              const Text(
                'SUSU does not knowingly collect any Personal Identifiable Information from children under the age of 13. If you think that your child provided this kind of information on our App, we strongly encourage you to contact us immediately and we will do our best efforts to promptly remove such information from our records.',
              ),
              const SizedBox(height: 16),
              const Text(
                'Online Privacy Policy Only',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'This Privacy Policy applies only to our online activities and is valid for visitors to our App with regards to the information that they shared and/or collect in SUSU. This policy is not applicable to any information collected offline or via channels other than this app. Our Privacy Policy was created with the help of the App Privacy Policy Generator from App-Privacy-Policy.com',
              ),
              const SizedBox(height: 16),
              const Text(
                'Consent',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'By using our app, you hereby consent to our Privacy Policy and agree to its Terms and Conditions.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
