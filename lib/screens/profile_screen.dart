import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final String referralCode = 'AG12345';
  final String referralUrl = 'https://adhyanguru.app/ref/AG12345';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Copied to clipboard!'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _shareViaWhatsApp() async {
    final message = 'Join Adhyanguru using my referral code: $referralCode\n$referralUrl';
    final whatsappUrl = 'whatsapp://send?text=${Uri.encodeComponent(message)}';
    
    try {
      if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
        await launchUrl(Uri.parse(whatsappUrl));
      } else {
        // Fallback to share_plus if WhatsApp is not installed
        await Share.share(message);
      }
    } catch (e) {
      await Share.share(message);
    }
  }

  Future<void> _shareViaFacebook() async {
    final message = 'Join Adhyanguru using my referral code: $referralCode\n$referralUrl';
    final facebookUrl = 'https://www.facebook.com/sharer/sharer.php?u=${Uri.encodeComponent(referralUrl)}';
    
    try {
      if (await canLaunchUrl(Uri.parse(facebookUrl))) {
        await launchUrl(Uri.parse(facebookUrl), mode: LaunchMode.externalApplication);
      } else {
        await Share.share(message);
      }
    } catch (e) {
      await Share.share(message);
    }
  }

  Future<void> _shareViaMessages() async {
    final message = 'Join Adhyanguru using my referral code: $referralCode\n$referralUrl';
    final smsUrl = 'sms:?body=${Uri.encodeComponent(message)}';
    
    try {
      if (await canLaunchUrl(Uri.parse(smsUrl))) {
        await launchUrl(Uri.parse(smsUrl));
      } else {
        await Share.share(message);
      }
    } catch (e) {
      await Share.share(message);
    }
  }

  Future<void> _shareGeneral() async {
    final message = 'Join Adhyanguru using my referral code: $referralCode\n$referralUrl';
    await Share.share(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Profile Header Card
                  _buildProfileHeader(),
                  const SizedBox(height: 20),
                  // Referral Section
                  _buildReferralSection(),
                  const SizedBox(height: 20),
                  // Share Options
                  _buildShareSection(),
                  const SizedBox(height: 20),
                  // Menu Items
                  _buildProfileItem(Icons.person, 'Personal Information'),
                  _buildProfileItem(Icons.settings, 'Settings'),
                  _buildProfileItem(Icons.notifications, 'Notifications'),
                  _buildProfileItem(Icons.help, 'Help & Support'),
                  _buildProfileItem(Icons.logout, 'Logout', isLogout: true),
                  SizedBox(height: MediaQuery.of(context).padding.bottom + 100),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[400]!, Colors.blue[600]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.network(
                'https://i.pravatar.cc/150?img=12',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Hard Raviya',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Agent ID: $referralCode',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReferralSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.purple[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.card_giftcard,
                  color: Colors.purple[600],
                  size: 24,
                ),
              ),
              const SizedBox(width: 15),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Referral',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Share and earn rewards',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Referral Code
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Referral Code',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        referralCode,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => _copyToClipboard(referralCode),
                  icon: Icon(Icons.copy, color: Colors.blue[600]),
                  tooltip: 'Copy Code',
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          // Referral URL
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Referral URL',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        referralUrl,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.blue[600],
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => _copyToClipboard(referralUrl),
                  icon: Icon(Icons.copy, color: Colors.blue[600]),
                  tooltip: 'Copy URL',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShareSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Share Referral',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildShareButton(
                icon: Icons.chat_bubble,
                label: 'WhatsApp',
                color: const Color(0xFF25D366),
                onTap: _shareViaWhatsApp,
              ),
              _buildShareButton(
                icon: Icons.public,
                label: 'Facebook',
                color: const Color(0xFF1877F2),
                onTap: _shareViaFacebook,
              ),
              _buildShareButton(
                icon: Icons.message,
                label: 'Messages',
                color: Colors.blue,
                onTap: _shareViaMessages,
              ),
              _buildShareButton(
                icon: Icons.share,
                label: 'More',
                color: Colors.grey[600]!,
                onTap: _shareGeneral,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShareButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String title, {bool isLogout = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isLogout ? Colors.red[50] : Colors.blue[50],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: isLogout ? Colors.red : Colors.blue,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isLogout ? Colors.red : Colors.black87,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey[400],
        ),
        onTap: () {},
      ),
    );
  }
}
