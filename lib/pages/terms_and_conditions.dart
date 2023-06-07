import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terms and Conditions'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terms and Conditions',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Welcome to SUSU!',
            ),
            SizedBox(height: 8),
            Text(
              'These terms and conditions outline the rules and regulations for the use of SUSU.',
            ),
            SizedBox(height: 8),
            Text(
              'By using this app we assume you accept these terms and conditions. Do not continue to use SUSU if you do not agree to take all of the terms and conditions stated on this page.',
            ),
            SizedBox(height: 16),
            Text(
              'License',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Unless otherwise stated, SUSU and/or its licensors own the intellectual property rights for all material on SUSU. All intellectual property rights are reserved. You may access this from SUSU for your own personal use subjected to restrictions set in these terms and conditions.',
            ),
            SizedBox(height: 8),
            Text(
              'You must not:',
            ),
            SizedBox(height: 4),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Republish material from SUSU'),
                  Text('Sell, rent or sub-license material from SUSU'),
                  Text('Reproduce, duplicate or copy material from SUSU'),
                  Text('Redistribute content from SUSU'),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text(
              'This Agreement shall begin on the date hereof.',
            ),
            SizedBox(height: 16),
            Text(
              'Parts of this app offer an opportunity for users to post and exchange opinions and information in certain areas of the website. SUSU does not filter, edit, publish or review Comments prior to their presence on the website. Comments do not reflect the views and opinions of SUSU, its agents and/or affiliates. Comments reflect the views and opinions of the person who post their views and opinions. To the extent permitted by applicable laws, SUSU shall not be liable for the Comments or for any liability, damages or expenses caused and/or suffered as a result of any use of and/or posting of and/or appearance of the Comments on this website.',
            ),
            SizedBox(height: 16),
            Text(
              'SUSU reserves the right to monitor all Comments and to remove any Comments which can be considered inappropriate, offensive or causes breach of these Terms and Conditions.',
            ),
            SizedBox(height: 16),
            Text(
              'You warrant and represent that:',
            ),
            SizedBox(height: 4),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('You are entitled to post the Comments on our App and have all necessary licenses and consents to do so;'),
                  Text('The Comments do not invade any intellectual property right, including without limitation copyright, patent or trademark of any third party;'),
                  Text('The Comments do not contain any defamatory, libelous, offensive, indecent or otherwise unlawful material which is an invasion of privacy'),
                  Text('The Comments will not be used to solicit or promote business or custom or present commercial activities or unlawful activity.'),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text(
              'You hereby grant SUSU a non-exclusive license to use, reproduce, edit and authorize others to use, reproduce and edit any of your Comments in any and all forms, formats or media.',
            ),
            SizedBox(height: 16),
            Text(
              'Hyperlinking to our App',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'The following organizations may link to our App without prior written approval:',
            ),
            SizedBox(height: 4),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Government agencies;'),
                  Text('Search engines;'),
                  Text('News organizations;'),
                  Text('Online directory distributors may link to our App in the same manner as they hyperlink to the Websites of other listed businesses; and'),
                  Text('System wide Accredited Businesses except soliciting non-profit organizations, charity shopping malls, and charity fundraising groups which may not hyperlink to our Web site.'),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text(
              'These organizations may link to our home page, to publications or to other App information so long as the link: (a) is not in any way deceptive; (b) does not falsely imply sponsorship, endorsement or approval of the linking party and its products and/or services; and (c) fits within the context of the linking party\'s site.',
            ),
            SizedBox(height: 16),
            Text(
              'We may consider and approve other link requests from the following types of organizations:',
            ),
            SizedBox(height: 4),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('commonly-known consumer and/or business information sources;'),
                  Text('dot.com community sites;'),
                  Text('associations or other groups representing charities;'),
                  Text('online directory distributors;'),
                  Text('internet portals;'),
                  Text('accounting, law and consulting firms; and'),
                  Text('educational institutions and trade associations.'),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text(
              'We will approve link requests from these organizations if we decide that: (a) the link would not make us look unfavorably to ourselves or to our accredited businesses; (b) the organization does not have any negative records with us; (c) the benefit to us from the visibility of the hyperlink compensates the absence of SUSU; and (d) the link is in the context of general resource information.',
            ),
            SizedBox(height: 16),
            Text(
              'These organizations may link to our App so long as the link: (a) is not in any way deceptive; (b) does not falsely imply sponsorship, endorsement or approval of the linking party and its products or services; and (c) fits within the context of the linking party\'s site.',
            ),
            SizedBox(height: 16),
            Text(
              'If you are one of the organizations listed in paragraph 2 above and are interested in linking to our App, you must inform us by sending an e-mail to SUSU. Please include your name, your organization name, contact information as well as the URL of your site, a list of any URLs from which you intend to link to our App, and a list of the URLs on our site to which you would like to link. Wait 2-3 weeks for a response.',
            ),
            SizedBox(height: 16),
            Text(
              'Approved organizations may hyperlink to our App as follows:',
            ),
            SizedBox(height: 4),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('By use of our corporate name; or'),
                  Text('By use of the uniform resource locator being linked to; or'),
                  Text('By use of any other description of our App being linked to that makes sense within the context and format of content on the linking party\'s site.'),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text(
              'No use of SUSU\'s logo or other artwork will be allowed for linking absent a trademark license agreement.',
            ),
            SizedBox(height: 16),
            Text(
              'iFrames',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Without prior approval and written permission, you may not create frames around our Webpages that alter in any way the visual presentation or appearance of our App.',
            ),
            SizedBox(height: 16),
            Text(
              'Content Liability',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'We shall not be hold responsible for any content that appears on your App. You agree to protect and defend us against all claims that is rising on our App. No link(s) should appear on any Website that may be interpreted as libelous, obscene or criminal, or which infringes, otherwise violates, or advocates the infringement or other violation of, any third party rights.',
            ),
            SizedBox(height: 16),
            Text(
              'Reservation of Rights',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'We reserve the right to request that you remove all links or any particular link to our App. You approve to immediately remove all links to our App upon request. We also reserve the right to amen these terms and conditions and it\'s linking policy at any time. By continuously linking to our App, you agree to be bound to and follow these linking terms and conditions.',
            ),
            SizedBox(height: 16),
            Text(
              'Removal of links from our App',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'If you find any link on our App that is offensive for any reason, you are free to contact and inform us any moment. We will consider requests to remove links but we are not obligated to or so or to respond to you directly.',
            ),
            SizedBox(height: 16),
            Text(
              'We do not ensure that the information on this website is correct, we do not warrant its completeness or accuracy; nor do we promise to ensure that the website remains available or that the material on the website is kept up to date.',
            ),
            SizedBox(height: 16),
            Text(
              'Disclaimer',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'To the maximum extent permitted by applicable law, we exclude all representations, warranties and conditions relating to our App and the use of this website. Nothing in this disclaimer will:',
            ),
            SizedBox(height: 4),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('limit or exclude our or your liability for death or personal injury;'),
                  Text('limit or exclude our or your liability for fraud or fraudulent misrepresentation;'),
                  Text('limit any of our or your liabilities in any way that is not permitted under applicable law; or'),
                  Text('exclude any of our or your liabilities that may not be excluded under applicable law.'),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text(
              'The limitations and prohibitions of liability set in this Section and elsewhere in this disclaimer: (a) are subject to the preceding paragraph; and (b) govern all liabilities arising under the disclaimer, including liabilities arising in contract, in tort and for breach of statutory duty.',
            ),
            SizedBox(height: 16),
            Text(
              'As long as the App and the information and services on the App are provided free of charge, we will not be liable for any loss or damage of any nature.',
            ),
          ],
        ),
      ),
    );
  }
}
