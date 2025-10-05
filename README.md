# shorten-links

A Flutter project for URL shortening.

## Getting Started

### Prerequisites

- Flutter SDK (version 3.8.1 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- Android device/emulator or iOS device/simulator

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd shorten_links
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate mock files (for testing)**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### First Time Usage

- The app will start with an empty link list
- Enter a valid URL in the input field at the top
- Tap the send button to shorten the URL
- View your shortened links in the list below


## Possible Improvements

The following features could be implemented to enhance the user experience and functionality:

### Duplicate Prevention
- **Avoid shortening the same link in sequence**: Implement logic to prevent users from shortening the same URL multiple times in a row, reducing server load and avoiding duplicate entries in the link list.

### Input Validation
- **Validate URL format before sending to server**: Add client-side validation to check if the entered text is a valid URL format before making the API call. This improves user experience by providing immediate feedback and reduces unnecessary network requests.

### Offline Support
- **Handle offline state**: Implement offline detection and provide appropriate user feedback when the device is not connected to the internet. This could include:
  - Showing a clear offline indicator
  - Caching successful shorten requests for later sync
  - Displaying helpful messages about network connectivity
  - Graceful handling of network errors
