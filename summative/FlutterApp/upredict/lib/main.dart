import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const SMEJobCreationApp());
}

class SMEJobCreationApp extends StatelessWidget {
  const SMEJobCreationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SME Job Creation Predictor',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'uPredict',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: false,
        elevation: 0,
        foregroundColor: Colors.white,
        backgroundColor: Colors.green.shade600,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PredictionPage(),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              margin: EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.green.shade600),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Predict',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.green.shade600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hero Image Section
            Container(
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/high-angle-friends-with-face-mask-concept.jpg',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.6),
                    ],
                  ),
                ),
              ),
            ),

            // Content Section
            Padding(
              padding: const EdgeInsets.all(28.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Message
                  Text(
                    'Welcome to uPredict',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade900,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Mission Statement
                  Text(
                    'Empowering Africa\'s Future',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.green.shade700,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Description
                  Text(
                    'Predict job creation potential in African SMEs through AI-powered digital transformation insights. Help eradicate youth unemployment by identifying high-impact businesses.',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Stats Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatCard('97.9%', 'Accuracy'),
                      _buildStatCard('5', 'Countries'),
                      _buildStatCard('1000', 'SMEs'),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // CTA Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.green.shade600,
                        foregroundColor: Colors.white,
                        elevation: 2,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PredictionPage(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.analytics, size: 24),
                      label: const Text(
                        'Start Prediction',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // About Button
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AboutPage(),
                          ),
                        );
                      },
                      child: Text(
                        'Learn More About This Project',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.green.shade700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}

class PredictionPage extends StatefulWidget {
  const PredictionPage({super.key});

  @override
  State<PredictionPage> createState() => _PredictionPageState();
}

class _PredictionPageState extends State<PredictionPage> {
  // REPLACE THIS WITH YOUR ACTUAL API URL AFTER DEPLOYMENT
  final String apiUrl =
      'https://linear-regression-model-sefx.onrender.com/predict';

  // Numeric controllers
  final TextEditingController revenueController = TextEditingController();
  final TextEditingController growthController = TextEditingController();
  final TextEditingController toolsController = TextEditingController(
    text: '2',
  );
  final TextEditingController revenuePerEmpController = TextEditingController();

  // Challenge indicators (binary)
  bool challengeCost = false;
  bool challengeSkills = false;
  bool challengeInternet = false;
  bool challengeRegulation = false;
  bool challengeAwareness = false;

  // Dropdown selections
  String? selectedCountry;
  String? selectedSector;
  String? selectedTechLevel;
  String? selectedFunding;
  String? selectedFemaleOwned;
  String? selectedRemoteWork;

  String resultText = '';
  String interpretationText = '';
  String countryText = '';
  String sectorText = '';
  String techLevelText = '';
  bool isLoading = false;
  bool hasError = false;

  final List<String> countries = [
    'Ghana',
    'Kenya',
    'Nigeria',
    'Rwanda',
    'South Africa',
  ];
  final List<String> sectors = [
    'Education',
    'Farming',
    'Finance',
    'Logistics',
    'Manufacturing',
    'Retail',
  ];
  final List<String> techLevels = ['High', 'Low', 'Medium'];
  final List<String> fundingStatuses = ['Bootstrapped', 'Seed', 'Series A'];
  final List<String> ownershipOptions = ['No', 'Yes'];
  final List<String> remoteOptions = ['Full', 'Partial'];

  @override
  void dispose() {
    revenueController.dispose();
    growthController.dispose();
    toolsController.dispose();
    revenuePerEmpController.dispose();
    super.dispose();
  }

  Future<void> makePrediction() async {
    // Validate inputs
    if (revenueController.text.isEmpty ||
        growthController.text.isEmpty ||
        toolsController.text.isEmpty ||
        revenuePerEmpController.text.isEmpty ||
        selectedCountry == null ||
        selectedSector == null ||
        selectedTechLevel == null ||
        selectedFunding == null ||
        selectedFemaleOwned == null ||
        selectedRemoteWork == null) {
      setState(() {
        hasError = true;
        resultText = 'Error: All fields are required!';
        interpretationText = '';
      });
      return;
    }

    setState(() {
      isLoading = true;
      resultText = '';
      interpretationText = '';
      hasError = false;
    });

    try {
      // Parse numeric values
      double annualRevenue = double.parse(revenueController.text);
      double growth = double.parse(growthController.text);
      int tools = int.parse(toolsController.text);
      double revenuePerEmp = double.parse(revenuePerEmpController.text);

      // Prepare request body with all 30 features
      final Map<String, dynamic> requestBody = {
        // Numeric features
        'annual_revenue': annualRevenue,
        'growth_last_yr': growth,
        'num_digital_tools': tools,
        'revenue_per_employee': revenuePerEmp,

        // Challenge indicators
        'challenge_cost': challengeCost ? 1 : 0,
        'challenge_skills': challengeSkills ? 1 : 0,
        'challenge_internet': challengeInternet ? 1 : 0,
        'challenge_regulation': challengeRegulation ? 1 : 0,
        'challenge_awareness': challengeAwareness ? 1 : 0,

        // Country indicators (one-hot encoded)
        'country_Ghana': selectedCountry == 'Ghana' ? 1 : 0,
        'country_Kenya': selectedCountry == 'Kenya' ? 1 : 0,
        'country_Nigeria': selectedCountry == 'Nigeria' ? 1 : 0,
        'country_Rwanda': selectedCountry == 'Rwanda' ? 1 : 0,
        'country_South_Africa': selectedCountry == 'South Africa' ? 1 : 0,

        // Sector indicators (one-hot encoded)
        'sector_Education': selectedSector == 'Education' ? 1 : 0,
        'sector_Farming': selectedSector == 'Farming' ? 1 : 0,
        'sector_Finance': selectedSector == 'Finance' ? 1 : 0,
        'sector_Logistics': selectedSector == 'Logistics' ? 1 : 0,
        'sector_Manufacturing': selectedSector == 'Manufacturing' ? 1 : 0,
        'sector_Retail': selectedSector == 'Retail' ? 1 : 0,

        // Tech adoption level (one-hot encoded)
        'tech_adoption_level_High': selectedTechLevel == 'High' ? 1 : 0,
        'tech_adoption_level_Low': selectedTechLevel == 'Low' ? 1 : 0,
        'tech_adoption_level_Medium': selectedTechLevel == 'Medium' ? 1 : 0,

        // Funding status (one-hot encoded)
        'funding_status_Bootstrapped': selectedFunding == 'Bootstrapped'
            ? 1
            : 0,
        'funding_status_Seed': selectedFunding == 'Seed' ? 1 : 0,
        'funding_status_Series_A': selectedFunding == 'Series A' ? 1 : 0,

        // Female ownership (one-hot encoded)
        'female_owned_No': selectedFemaleOwned == 'No' ? 1 : 0,
        'female_owned_Yes': selectedFemaleOwned == 'Yes' ? 1 : 0,

        // Remote work policy (one-hot encoded)
        'remote_work_policy_Full': selectedRemoteWork == 'Full' ? 1 : 0,
        'remote_work_policy_Partial': selectedRemoteWork == 'Partial' ? 1 : 0,
      };

      // Make API call
      final response = await http
          .post(
            Uri.parse(apiUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(requestBody),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          resultText = '${data['predicted_employees']} employees';
          interpretationText = data['interpretation'] ?? '';
          countryText = data['country'] ?? '';
          sectorText = data['sector'] ?? '';
          techLevelText = data['tech_level'] ?? '';
          hasError = false;
          isLoading = false;
        });
      } else {
        final error = jsonDecode(response.body);
        setState(() {
          hasError = true;
          resultText = 'Error: ${error['detail'] ?? 'Unknown error'}';
          interpretationText = '';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
        resultText = 'Error: ${e.toString()}';
        interpretationText =
            'Please check your internet connection and API URL.';
        isLoading = false;
      });
    }
  }

  Widget buildTextField(
    TextEditingController controller,
    String label,
    String hint,
    IconData icon, {
    bool isInteger = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.numberWithOptions(decimal: !isInteger),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.grey.shade50,
        ),
      ),
    );
  }

  Widget buildDropdown<T>(
    String label,
    T? value,
    List<T> items,
    Function(T?) onChanged,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<T>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.grey.shade50,
        ),
        items: items.map((item) {
          return DropdownMenuItem<T>(value: item, child: Text(item.toString()));
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget buildCheckbox(String label, bool value, Function(bool?) onChanged) {
    return CheckboxListTile(
      title: Text(label),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.green,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Job Creation Predictor',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: false,
        elevation: 0,
        foregroundColor: Colors.white,
        backgroundColor: Colors.green.shade600,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Section
            Text(
              'Enter SME Details',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Provide business information to predict job creation potential',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade600,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 32),

            // Business Metrics Section
            Text(
              'Business Metrics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade700,
              ),
            ),
            const SizedBox(height: 15),

            buildTextField(
              revenueController,
              'Annual Revenue (USD)',
              'e.g., 500000',
              Icons.attach_money,
            ),

            buildTextField(
              growthController,
              'Growth Last Year (%)',
              'e.g., 25.5',
              Icons.trending_up,
            ),

            buildTextField(
              toolsController,
              'Number of Digital Tools (1-3)',
              'e.g., 2',
              Icons.computer,
              isInteger: true,
            ),

            buildTextField(
              revenuePerEmpController,
              'Revenue per Employee (USD)',
              'e.g., 2500',
              Icons.person_outline,
            ),

            const SizedBox(height: 32),

            // Challenges Section
            Text(
              'Current Challenges',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade700,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    buildCheckbox('Cost Challenges', challengeCost, (val) {
                      setState(() => challengeCost = val ?? false);
                    }),
                    buildCheckbox('Skills Gap Challenges', challengeSkills, (
                      val,
                    ) {
                      setState(() => challengeSkills = val ?? false);
                    }),
                    buildCheckbox(
                      'Internet/Connectivity Issues',
                      challengeInternet,
                      (val) {
                        setState(() => challengeInternet = val ?? false);
                      },
                    ),
                    buildCheckbox(
                      'Regulatory Challenges',
                      challengeRegulation,
                      (val) {
                        setState(() => challengeRegulation = val ?? false);
                      },
                    ),
                    buildCheckbox(
                      'Awareness/Marketing Issues',
                      challengeAwareness,
                      (val) {
                        setState(() => challengeAwareness = val ?? false);
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Company Details Section
            Text(
              'Company Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade700,
              ),
            ),
            const SizedBox(height: 15),

            buildDropdown<String>(
              'Country',
              selectedCountry,
              countries,
              (val) => setState(() => selectedCountry = val),
              Icons.flag,
            ),

            buildDropdown<String>(
              'Sector',
              selectedSector,
              sectors,
              (val) => setState(() => selectedSector = val),
              Icons.category,
            ),

            buildDropdown<String>(
              'Tech Adoption Level',
              selectedTechLevel,
              techLevels,
              (val) => setState(() => selectedTechLevel = val),
              Icons.signal_cellular_alt,
            ),

            buildDropdown<String>(
              'Funding Status',
              selectedFunding,
              fundingStatuses,
              (val) => setState(() => selectedFunding = val),
              Icons.account_balance,
            ),

            buildDropdown<String>(
              'Female-Owned',
              selectedFemaleOwned,
              ownershipOptions,
              (val) => setState(() => selectedFemaleOwned = val),
              Icons.business_center,
            ),

            buildDropdown<String>(
              'Remote Work Policy',
              selectedRemoteWork,
              remoteOptions,
              (val) => setState(() => selectedRemoteWork = val),
              Icons.home_work,
            ),

            const SizedBox(height: 25),

            // Predict Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : makePrediction,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Colors.green.shade600,
                  foregroundColor: Colors.white,
                  elevation: 2,
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.analytics, size: 24),
                          SizedBox(width: 10),
                          Text(
                            'Predict Job Creation',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
              ),
            ),

            const SizedBox(height: 32),

            // Result Display
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: hasError
                    ? Colors.red.shade50
                    : resultText.isEmpty
                    ? Colors.grey.shade50
                    : Colors.green.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: hasError
                      ? Colors.red.shade300
                      : resultText.isEmpty
                      ? Colors.grey.shade300
                      : Colors.green.shade300,
                  width: 1.5,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    hasError
                        ? Icons.error_outline
                        : resultText.isEmpty
                        ? Icons.info_outline
                        : Icons.check_circle_outline,
                    size: 50,
                    color: hasError
                        ? Colors.red
                        : resultText.isEmpty
                        ? Colors.grey
                        : Colors.green,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    resultText.isEmpty
                        ? 'Results will appear here'
                        : hasError
                        ? resultText
                        : 'Predicted Job Creation',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: hasError
                          ? Colors.red.shade700
                          : Colors.grey.shade700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (!hasError && resultText.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(
                      resultText,
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  if (countryText.isNotEmpty || sectorText.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 10,
                      children: [
                        if (countryText.isNotEmpty)
                          Chip(
                            avatar: const Icon(Icons.flag, size: 16),
                            label: Text(countryText),
                            backgroundColor: Colors.blue.shade100,
                          ),
                        if (sectorText.isNotEmpty)
                          Chip(
                            avatar: const Icon(Icons.category, size: 16),
                            label: Text(sectorText),
                            backgroundColor: Colors.purple.shade100,
                          ),
                        if (techLevelText.isNotEmpty)
                          Chip(
                            avatar: const Icon(
                              Icons.signal_cellular_alt,
                              size: 16,
                            ),
                            label: Text('$techLevelText Tech'),
                            backgroundColor: Colors.orange.shade100,
                          ),
                      ],
                    ),
                  ],
                  if (interpretationText.isNotEmpty) ...[
                    const SizedBox(height: 15),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Text(
                        interpretationText,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade800,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Icon(
                Icons.business_center,
                size: 80,
                color: Colors.green.shade600,
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'Our Mission',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'This application is dedicated to eradicating youth unemployment in Africa through job creation by predicting employment potential in African SMEs based on digital transformation strategies.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            _buildInfoCard(
              'How It Works',
              'Enter SME details including revenue, growth, digital tools, sector, and challenges. Our AI predicts how many jobs the company will create based on 1,000 African SMEs.',
              Icons.lightbulb_outline,
            ),
            const SizedBox(height: 15),
            _buildInfoCard(
              'Purpose',
              'Help entrepreneurs, investors, and policymakers identify high-potential SMEs for job creation and make data-driven decisions to boost youth employment.',
              Icons.flag_outlined,
            ),
            const SizedBox(height: 15),
            _buildInfoCard(
              'Technology',
              'Built with Flutter for mobile, FastAPI for backend, and Random Forest machine learning model (97.9% accuracy) trained on real African SME data from Ghana, Kenya, Nigeria, Rwanda, and South Africa.',
              Icons.code,
            ),
            const SizedBox(height: 15),
            _buildInfoCard(
              'Coverage',
              '5 Countries: Ghana, Kenya, Nigeria, Rwanda, South Africa\n6 Sectors: Education, Farming, Finance, Logistics, Manufacturing, Retail',
              Icons.public,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String description, IconData icon) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 30, color: Colors.green.shade600),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(description, style: const TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
